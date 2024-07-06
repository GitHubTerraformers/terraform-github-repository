data "external" "env" {
  program = ["bash", "${path.module}/env.sh"]
}

resource "null_resource" "patch" {
  triggers = {
    properties = jsonencode(var.properties)
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
  new_properties = jsonencode({
    "properties" = [for n, v in var.properties : {
      property_name = n
      value         = v
    }]
  })
}
