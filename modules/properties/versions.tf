terraform {
  required_version = ">= 1.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.2.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
