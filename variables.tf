variable "name" {
  description = "(Required) The name of the repository"
  type        = string
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

variable "visibility" {
  description = "(Optional) Can be public or private (or internal if your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+)"
  type        = string
  default     = null
  validation {
    condition     = var.visibility == null || can(regex("^public$|^private$|^internal$", var.visibility))
    error_message = "Only public, private and internal values are allowed"
  }
}

variable "has_issues" {
  description = "(Optional) True to enable the GitHub Issues features on the repository"
  type        = bool
  default     = null
}

variable "has_discussions" {
  description = "(Optional) True to enable GitHub Discussions on the repository. Defaults to false"
  type        = bool
  default     = null
}

variable "has_projects" {
  description = "(Optional) True to enable the GitHub Projects features, but it will return an error if it is disabled at organization level."
  type        = bool
  default     = null
}

variable "has_wiki" {
  description = "(Optional) Controls if Wifi feature is enabled."
  type        = bool
  default     = null
}

variable "is_template" {
  description = "(Optional) Set to true if this is a template repository"
  type        = bool
  default     = null
}

variable "allow_merge_commit" {
  description = "(Optional) Controls if merge commits is allowed. Defaults to true."
  type        = bool
  default     = null
}

variable "allow_squash_merge" {
  description = "(Optional) Controls if squash merging is allowed. Defaults to true."
  type        = bool
  default     = null
}

variable "allow_rebase_merge" {
  description = "(Optional) Controls if rebase merge is allowed. Defaults to true."
  type        = bool
  default     = null
}

variable "allow_auto_merge" {
  description = "(Optional) Controls if auto-merging pull requests are allowed."
  type        = bool
  default     = null
}

variable "squash_merge_commit_title" {
  description = "(Optional) Default squash merge title, can be PR_TITLE or COMMIT_OR_PR_TITLE. Needs allow_squash_merge = true"
  type        = string
  default     = null
  validation {
    condition     = var.squash_merge_commit_title == null || can(regex("^PR_TITLE$|^COMMIT_OR_PR_TITLE$", var.squash_merge_commit_title))
    error_message = "Only PR_TITLE and COMMIT_OR_PR_TITLE values are allowed"
  }
}

variable "squash_merge_commit_message" {
  description = "(Optional) Can be PR_BODY, COMMIT_MESSAGES, or BLANK for a default squash merge commit message. Applicable only if allow_squash_merge is true"
  type        = string
  default     = null
  validation {
    condition     = var.squash_merge_commit_message == null || can(regex("^PR_BODY$|^COMMIT_MESSAGES$|^BLANK$", var.squash_merge_commit_message))
    error_message = "Only PR_BODY, COMMIT_MESSAGES and BLANK values are allowed"
  }
}

check "squash_merge_commit_title_or_message_only_if_allowed_squash_merge" {
  assert {
    condition     = var.allow_squash_merge == null || (var.squash_merge_commit_title == null && var.squash_merge_commit_message == null) || var.allow_squash_merge == true
    error_message = "Applicable only if allow_squash_merge is true"
  }
}

check "squash_merge_commit_title_and_message_invalid_combination" {
  assert {
    condition     = var.squash_merge_commit_title != "COMMIT_OR_PR_TITLE" || var.squash_merge_commit_message == "COMMIT_MESSAGES"
    error_message = "Invalid combination squash_merge_commit_title & squash_merge_commit_message"
  }
}

variable "merge_commit_title" {
  description = "(Optional) Can be PR_TITLE or MERGE_MESSAGE for a default merge commit title. Applicable only if allow_merge_commit is true"
  type        = string
  default     = null
  validation {
    condition     = var.merge_commit_title == null || can(regex("^PR_TITLE$|^MERGE_MESSAGE$", var.merge_commit_title))
    error_message = "Only PR_TITLE and MERGE_MESSAGE values are allowed"
  }
}

variable "merge_commit_message" {
  description = "(Optional) Can be PR_BODY, PR_TITLE, or BLANK for a default merge commit message. Applicable only if allow_merge_commit is true"
  type        = string
  default     = null
  validation {
    condition     = var.merge_commit_message == null || can(regex("^PR_BODY$|^PR_TITLE$|^BLANK$", var.merge_commit_message))
    error_message = "Only PR_BODY, PR_TITLE and BLANK values are allowed"
  }
}

check "merge_commit_title_or_message_only_if_allowed_merge_commit" {
  assert {
    condition     = var.allow_merge_commit == null || (var.merge_commit_title == null && var.merge_commit_message == null) || var.allow_merge_commit == true
    error_message = "Applicable only if allow_merge_commit is true"
  }
}

check "merge_commit_title_and_message_invalid_combination" {
  assert {
    condition     = var.merge_commit_title != "MERGE_MESSAGE" || var.merge_commit_message == "PR_TITLE"
    error_message = "Invalid combination merge_commit_title & merge_commit_message"
  }
}

variable "delete_branch_on_merge" {
  description = "(Optional) Automatically delete head branch after a pull request is merged. Defaults to false"
  type        = bool
  default     = null
}

variable "web_commit_signoff_required" {
  description = "(Optional) Require contributors to sign off on web-based commits. See more here. Defaults to false"
  type        = bool
  default     = null
}

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

variable "topics" {
  description = "(Optional) The list of topics of the repository"
  type        = list(string)
  default     = null
}

variable "vulnerability_alerts" {
  description = "(Optional) Set to true to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level"
  type        = bool
  default     = null
}

variable "ignore_vulnerability_alerts_during_read" {
  description = "(Optional) Set to true to not call the vulnerability alerts endpoint so the resource can also be used without admin permissions during read"
  type        = bool
  default     = null
}

variable "allow_update_branch" {
  description = "(Optional) Set to true to always suggest updating pull request branches"
  type        = bool
  default     = null
}

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

variable "dependabot_security_updates" {
  description = "(Optional) The repository's Dependabot security updates configuration"
  type        = bool
  default     = null
}

variable "security_and_analysis" {
  description = "(Optional) The repository's security and analysis configuration"
  type = object({
    advanced_security               = optional(bool)
    secret_scanning                 = optional(bool)
    secret_scanning_push_protection = optional(bool)
  })
  default = null
}

check "advanced_security_needed_for_secret_scanning" {
  assert {
    condition     = var.security_and_analysis == null || try(var.security_and_analysis.advanced_security, null) == true || (try(var.security_and_analysis.secret_scanning, null) == false && try(var.security_and_analysis.secret_scanning, null) == false)
    error_message = "security_and_analisys.advanced_security must be true to enable secret_scanning for private repositories"
  }
}

variable "template" {
  description = "(Optional) Use a template repository to create this resource"
  type = object({
    owner                = optional(string)
    repository           = optional(string)
    include_all_branches = optional(bool)
  })
  default = null
}

variable "default_branch" {
  description = "(Optional) base branch against which all pull requests and code commits are automatically made unless you specify a different branch"
  type        = string
  default     = null
}

variable "collaborators" {
  description = "(Optional) The list of collaborators of the repository"
  type = object({
    users = optional(map(string), {})
    teams = optional(map(string), {})
  })
  default = {}
}

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

variable "issue_labels" {
  description = "(Optional) The list of issue labels of the repository (key: label_name)"
  type = map(object({
    color       = string
    description = optional(string)
  }))
  default = null
}

variable "autolink_references" {
  description = "(Optional) The list of autolink references of the repository (key: key_prefix)"
  type = map(object({
    target_url_template = string
    is_alphanumeric     = optional(bool)
  }))
  default = {}
}

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

variable "deploy_keys" {
  description = "(Optional) The list of deploy keys of the repository (key: key_title)"
  type = map(object({
    key       = string
    read_only = optional(bool, true)
  }))
  default = null
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

variable "actions" {
  description = "(Optional) The list of actions configuration of the repository"
  type = object({
    access_level = optional(string)
    permissions = optional(object({
      enabled         = optional(bool)
      allowed_actions = optional(string)
      allowed_actions_config = optional(object({
        github_owned_allowed = optional(bool)
        patterns_allowed     = optional(list(string))
        verified_allowed     = optional(bool)
      }))
    }))
    secrets = optional(map(object({
      encrypted_value = optional(string)
      plaintext_value = optional(string)
    })))
    variables = optional(map(string))
    environments = optional(map(object({
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
    })))
  })
  default = null
  validation {
    condition     = var.actions == null || try(var.actions.access_level, null) == null || can(regex("^none$|^user$|^organization$|^enterprise$", var.actions.access_level))
    error_message = "access_level: Only none, user, organization and enterprise values are allowed"
  }
  validation {
    condition     = var.actions == null || try(var.actions.permissions, null) == null || try(var.actions.permissions.allowed_actions, null) == null || can(regex("^all$|^local_only$|^selected$", var.actions.permissions.allowed_actions))
    error_message = "permissions.allowed_actions: Only all, local_only and selected values are allowed"
  }
}


variable "properties" {
  description = "(Optional) The list of properties of the repository (key: property_name)"
  type        = map(string)
  default     = null
}
