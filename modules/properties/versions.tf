terraform {
  required_version = ">= 1.6"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}
