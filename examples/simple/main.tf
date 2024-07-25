provider "github" {
}

module "repo" {
  source = "../.."

  name           = "my-repo"
  visibility     = "private"
  default_branch = "main"
  template       = "MarketingPipeline/Awesome-Repo-Template"
}
