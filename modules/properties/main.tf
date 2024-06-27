data "external" "env" {
  program = ["bash", "${path.module}/env.sh"]
}

data "github_rest_api" "this" {
  endpoint   = format("repos/%s/%s/properties/values", data.external.env.result["GITHUB_OWNER"], var.repository)
  depends_on = [data.external.env]
}

resource "null_resource" "put_properties" {
  count = jsonencode(local.current_properties) == jsonencode(var.properties) ? 0 : 1
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOM
      curl --silent --fail  --show-error --retry-connrefused \
        -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${data.external.env.result["GITHUB_TOKEN"]}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/${data.external.env.result["GITHUB_OWNER"]}/${var.repository}/properties/values \
        -d '${local.new_properties}'
    EOM
  }
}

locals {
  current_properties = {
    for e in try(jsondecode(data.github_rest_api.this.body), []) : e.property_name => e.value
  }
  new_properties = jsonencode({
    "properties" = [for n, v in var.properties : {
      property_name = n
      value         = v
    }]
  })
}
