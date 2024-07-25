# General

variable "name" {
  description = "(Required) The name of the repository"
  type        = string
}

variable "rename_to" {
  description = "(Optional) New name for this repository (useful for renaming, but not changing the name of the resource)"
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) A description of the repository"
  type        = string
  default     = null
}

variable "homepage_url" {
  description = "(Optional) URL of a page describing the project"
  type        = string
  default     = null
}

variable "is_template" {
  description = "(Optional) Set to true if this is a template repository"
  type        = bool
  default     = null
}

variable "web_commit_signoff_required" {
  description = "(Optional) Require contributors to sign off on web-based commits. See more here. Defaults to false"
  type        = bool
  default     = null
}

variable "default_branch" {
  description = "(Optional) base branch against which all pull requests and code commits are automatically made unless you specify a different branch"
  type        = string
  default     = null
}


# Content initialization

variable "auto_init" {
  description = "(Optional) Set to true to produce an initial commit in the repository"
  type        = bool
  default     = null
}

variable "gitignore_template" {
  description = "(Optional) Use the name of the template without the extension. See https://github.com/github/gitignore"
  type        = string
  default     = null
}

variable "license_template" {
  description = "(Optional) Use the name of the template without the extension. See https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  type        = string
  default     = null
}

variable "template" {
  description = "(Optional) Use a template repository to create this resource (owner/repo)"
  type        = string
  default     = null
}


# Features

variable "features" {
  description = "(Optional) The features of the repository (wiki, issues, discussions, projects)"
  type        = list(string)
  default     = []
}

variable "issue_labels" {
  description = "(Optional) The list of issue labels of the repository (key: label_name)"
  type = map(object({
    color       = string
    description = optional(string)
  }))
  default = null
}

# Pull Requests

variable "pull_requests" {
  description = "(Optional) The pull requests configuration of the repository"
  type = object({
    allowed_merge_types    = optional(list(string), ["squash", "rebase", "commit"]) # may include "squash", "rebase", "commit"
    commit_message         = optional(map(string))                                  # key: squash, commit
    auto_merge             = optional(bool)
    delete_branch_on_merge = optional(bool)
    update_branch          = optional(bool)
  })
  default = {
    allowed_merge_types = ["squash", "rebase", "commit"]
  }
}

# Danger Zone

variable "visibility" {
  description = "(Optional) Can be public or private (or internal if your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+)"
  type        = string
  default     = null
  validation {
    condition     = var.visibility == null || can(regex("^public$|^private$|^internal$", var.visibility))
    error_message = "Only public, private and internal values are allowed"
  }
}

variable "archived" {
  description = "(Optional) Specifies if the repository should be archived. Defaults to false."
  type        = bool
  default     = null
}

variable "archive_on_destroy" {
  description = "(Optional) Set to true to archive the repository instead of deleting on destroy"
  type        = bool
  default     = null
}


# Collaborators

variable "collaborators" {
  description = "(Optional) The list of collaborators of the repository"
  type = object({
    users = optional(map(string), {})
    teams = optional(map(string), {})
  })
  default = {}
}


# Topics

variable "topics" {
  description = "(Optional) The list of topics of the repository"
  type        = list(string)
  default     = null
}


# Rules

variable "rulesets" {
  description = "(Optional) Repository rules"
  type = map(object({
    enforcement = optional(string, "active")
    rules = optional(object({
      branch_name_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))
      commit_author_email_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))
      commit_message_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))
      committer_email_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))
      creation         = optional(bool)
      deletion         = optional(bool)
      non_fast_forward = optional(bool)
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool)
        require_code_owner_review         = optional(bool)
        require_last_push_approval        = optional(bool)
        required_approving_review_count   = optional(number)
        required_review_thread_resolution = optional(bool)
      }))
      required_deployment_environments     = optional(list(string))
      required_linear_history              = optional(bool)
      required_signatures                  = optional(bool)
      required_status_checks               = optional(map(string))
      strict_required_status_checks_policy = optional(bool)
      tag_name_pattern = optional(object({
        operator = optional(string)
        pattern  = optional(string)
        name     = optional(string)
        negate   = optional(bool)
      }))
      update                        = optional(bool)
      update_allows_fetch_and_merge = optional(bool)
    }))
    target = optional(string, "branch")
    bypass_actors = optional(map(object({
      actor_type  = string
      bypass_mode = string
    })))
    include = optional(list(string), [])
    exclude = optional(list(string), [])
  }))
  default = {}
  validation {
    condition     = alltrue([for name, config in(var.rulesets == null ? {} : var.rulesets) : contains(["active", "evaluate", "disabled"], config.enforcement)])
    error_message = "Possible values for enforcement are active, evaluate or disabled."
  }
  validation {
    condition     = alltrue([for name, config in(var.rulesets == null ? {} : var.rulesets) : contains(["tag", "branch"], config.target)])
    error_message = "Possible values for ruleset target are tag or branch"
  }
}


# Actions

variable "actions_permissions" {
  description = "(Optional) The list of permissions configuration of the repository"
  type = object({
    enabled         = optional(bool)
    allowed_actions = optional(string)
    allowed_actions_config = optional(object({
      github_owned_allowed = optional(bool)
      patterns_allowed     = optional(list(string))
      verified_allowed     = optional(bool)
    }))
  })
  default = null
  validation {
    condition     = var.actions_permissions == null || try(var.actions_permissions.allowed_actions, null) == null || can(regex("^all$|^local_only$|^selected$", var.actions_permissions.allowed_actions))
    error_message = "permissions.allowed_actions: Only all, local_only and selected values are allowed"
  }
}

variable "actions_access_level" {
  description = "(Optional) The access level for the repository. Must be one of none, user, organization, or enterprise. Default: none"
  type        = string
  default     = null
  validation {
    condition     = var.actions_access_level == null || can(regex("^none$|^user$|^organization$|^enterprise$", var.actions_access_level))
    error_message = "Only none, user, organization and enterprise values are allowed"
  }
}


# Webhooks

variable "webhooks" {
  description = "(Optional) The list of webhooks of the repository (key: webhook_url)"
  type = map(object({
    content_type = string
    insecure_ssl = optional(bool, false)
    secret       = optional(string)
    events       = optional(list(string))
  }))
  default = null
  validation {
    condition     = alltrue([for url, config in(var.webhooks == null ? {} : var.webhooks) : contains(["form", "json"], config.content_type)])
    error_message = "Possible values for content_type are json or form."
  }
}


# Environments

variable "environments" {
  description = "(Optional) The list of environments configuration of the repository (key: environment_name)"
  type = map(object({
    wait_timer          = optional(number)
    can_admins_bypass   = optional(bool)
    prevent_self_review = optional(bool)
    reviewers = optional(object({
      users = optional(map(string), {})
      teams = optional(map(string), {})
    }))
    deployment_branch_policy = optional(object({
      protected_branches     = optional(bool, false)
      custom_branch_policies = optional(list(string), [])
    }))
    secrets = optional(map(object({
      encrypted_value = optional(string)
      plaintext_value = optional(string)
    })))
    variables = optional(map(string))
  }))
  default = null
}


# Pages

variable "pages" {
  description = "(Optional) The repository's GitHub Pages configuration"
  type = object({
    source = optional(object({
      branch = string
      path   = optional(string, "/")
    }))
    build_type = optional(string, "legacy")
    cname      = optional(string)
  })
  default = null
  validation {
    condition     = contains(["workflow", "legacy"], try(var.pages.build_type, "workflow")) && ((try(var.pages.build_type, "null") != "legacy") || can(var.pages.source.branch))
    error_message = "build_type must be legacy or workflow. If you use legacy as build type you need to set the option source"
  }
}


# Custom properties

variable "properties" {
  description = "(Optional) The list of properties of the repository (key: property_name)"
  type        = map(string)
  default     = null
}


# Code security and analysis

variable "security" {
  description = "(Optional) The list of security features enabled for the repository."
  type        = list(string)
  default     = []
}

# Deploy keys

variable "deploy_keys" {
  description = "(Optional) The list of deploy keys of the repository (key: key_title)"
  type = map(object({
    key       = optional(string) # auto-generated if not provided
    read_only = optional(bool, true)
  }))
  default = null
}

variable "deploy_keys_path" {
  description = "(Optional) The path to the generated deploy keys for this repository"
  type        = string
  default     = "./deploy_keys"
}


# Secrets and variables

variable "secrets" {
  description = "(Optional) The list of secrets configuration of the repository (key: secret_name)"
  type = map(object({
    encrypted_value = optional(string)
    plaintext_value = optional(string)
  }))
  default = null
}

variable "variables" {
  description = "(Optional) The list of variables configuration of the repository (key: variable_name)"
  type        = map(string)
  default     = null
}


# Other

variable "autolink_references" {
  description = "(Optional) The list of autolink references of the repository (key: key_prefix)"
  type = map(object({
    target_url_template = string
    is_alphanumeric     = optional(bool)
  }))
  default = {}
}

variable "files" {
  description = "(Optional) The list of files of the repository (key: file_path)"
  type = map(object({
    content             = optional(string)
    from_file           = optional(string)
    branch              = optional(string)
    commit_author       = optional(string)
    commit_email        = optional(string)
    commit_message      = optional(string)
    overwrite_on_create = optional(bool)
  }))
  default = null
}
