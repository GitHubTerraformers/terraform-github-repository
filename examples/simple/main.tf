provider "github" {
  owner = var.owner
}

module "repo" {
  source = "../.."

  name           = "my-repo"
  visibility     = "private"
  default_branch = "main"
  template = {
    owner      = "MarketingPipeline"
    repository = "Awesome-Repo-Template"
  }
}
