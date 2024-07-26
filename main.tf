locals {
  allowed_merge_types = try(var.pull_requests["allowed_merge_types"], ["commit", "squash", "rebase"])
}

resource "github_repository" "this" {
  name                                    = var.repository_name != null ? var.repository_name : var.name
  description                             = var.description
  homepage_url                            = var.url
  visibility                              = var.visibility
  has_issues                              = contains(var.features, "issues")
  has_discussions                         = contains(var.features, "discussions")
  has_projects                            = contains(var.features, "projects")
  has_wiki                                = contains(var.features, "wiki")
  is_template                             = var.is_template
  allow_merge_commit                      = contains(local.allowed_merge_types, "commit")
  allow_squash_merge                      = contains(local.allowed_merge_types, "squash")
  allow_rebase_merge                      = contains(local.allowed_merge_types, "rebase")
  allow_auto_merge                        = lookup(var.pull_requests, "auto_merge", null)
  allow_update_branch                     = lookup(var.pull_requests, "update_branch", null)
  delete_branch_on_merge                  = lookup(var.pull_requests, "delete_branch_on_merge", null)
  squash_merge_commit_title               = try(element(split(":", lookup(var.pull_requests.commit_message, "squash", null)), 0), null)
  squash_merge_commit_message             = try(element(split(":", lookup(var.pull_requests.commit_message, "squash", null)), 1), null)
  merge_commit_title                      = try(element(split(":", lookup(var.pull_requests.commit_message, "commit", null)), 0), null)
  merge_commit_message                    = try(element(split(":", lookup(var.pull_requests.commit_message, "commit", null)), 1), null)
  web_commit_signoff_required             = var.web_commit_signoff_required
  auto_init                               = var.default_branch != null
  archived                                = var.archived
  archive_on_destroy                      = var.archive_on_destroy
  topics                                  = var.topics
  vulnerability_alerts                    = contains(var.security, "dependabot_alerts")
  ignore_vulnerability_alerts_during_read = contains(var.security, "ignore_vulnerability_alerts_during_read")

  dynamic "pages" {
    for_each = var.pages != null ? [1] : []
    content {
      dynamic "source" {
        for_each = var.pages.source != null ? [1] : []
        content {
          branch = var.pages.source.branch
          path   = var.pages.source.path
        }
      }
      build_type = var.pages.build_type
      cname      = var.pages.cname
    }
  }

  dynamic "security_and_analysis" {
    for_each = contains(var.security, "advanced") || contains(var.security, "secret_scanning") ? [1] : []
    content {
      dynamic "advanced_security" {
        for_each = contains(var.security, "advanced") ? [1] : [] ? [1] : []
        content {
          status = "enabled"
        }
      }
      dynamic "secret_scanning" {
        for_each = contains(var.security, "secret_scanning") ? [1] : []
        content {
          status = "enabled"
        }
      }
      dynamic "secret_scanning_push_protection" {
        for_each = contains(var.security, "secret_scanning_push_protection") ? [1] : [] ? [1] : []
        content {
          status = "enabled"
        }
      }
    }
  }

  dynamic "template" {
    for_each = var.template != null ? [1] : []
    content {
      owner      = try(element(split("/", var.template), 0), null)
      repository = try(element(split("/", var.template), 1), null)
      # include_all_branches = true
    }
  }
}

resource "github_repository_dependabot_security_updates" "this" {
  count      = contains(var.security, "dependabot_security_updates") ? 1 : 0
  repository = github_repository.this.name
  enabled    = true
}

# The default branch is considered the “base” branch in your repository,
# against which all pull requests and code commits are automatically made,
# unless you specify a different branch.
resource "github_branch_default" "this" {
  count      = try(var.default_branch, null) != null ? 1 : 0
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_repository_collaborators" "this" {
  count      = (var.teams != null || var.users != null) ? 1 : 0
  repository = github_repository.this.name
  dynamic "user" {
    for_each = try(var.users, null) != null ? var.users : {}
    content {
      permission = user.value
      username   = user.key
    }
  }
  dynamic "team" {
    for_each = try(var.teams, null) != null ? var.teams : {}
    content {
      permission = team.value
      team_id    = team.key
    }
  }
}

resource "github_repository_ruleset" "this" {
  for_each    = try(var.rulesets, null) != null ? var.rulesets : {}
  repository  = github_repository.this.name
  name        = each.key
  enforcement = each.value.enforcement
  rules {
    dynamic "branch_name_pattern" {
      for_each = try(each.value.rules.branch_name_pattern, null) != null ? [1] : []
      content {
        operator = each.value.rules.branch_name_pattern.operator
        pattern  = each.value.rules.branch_name_pattern.pattern
        name     = each.value.rules.branch_name_pattern.name
        negate   = each.value.rules.branch_name_pattern.negate
      }
    }
    dynamic "commit_author_email_pattern" {
      for_each = try(each.value.rules.commit_author_email_pattern, null) != null ? [1] : []
      content {
        operator = each.value.rules.commit_author_email_pattern.operator
        pattern  = each.value.rules.commit_author_email_pattern.pattern
        name     = each.value.rules.commit_author_email_pattern.name
        negate   = each.value.rules.commit_author_email_pattern.negate
      }
    }
    dynamic "commit_message_pattern" {
      for_each = try(each.value.rules.commit_message_pattern, null) != null ? [1] : []
      content {
        operator = each.value.rules.commit_message_pattern.operator
        pattern  = each.value.rules.commit_message_pattern.pattern
        name     = each.value.rules.commit_message_pattern.name
        negate   = each.value.rules.commit_message_pattern.negate
      }
    }
    dynamic "committer_email_pattern" {
      for_each = try(each.value.rules.committer_email_pattern, null) != null ? [1] : []
      content {
        operator = each.value.rules.committer_email_pattern.operator
        pattern  = each.value.rules.committer_email_pattern.pattern
        name     = each.value.rules.committer_email_pattern.name
        negate   = each.value.rules.committer_email_pattern.negate
      }
    }
    creation         = each.value.rules.creation
    deletion         = each.value.rules.deletion
    non_fast_forward = each.value.rules.non_fast_forward
    dynamic "pull_request" {
      for_each = try(each.value.rules.pull_request, null) != null ? [1] : []
      content {
        dismiss_stale_reviews_on_push     = each.value.rules.pull_request.dismiss_stale_reviews_on_push
        require_code_owner_review         = each.value.rules.pull_request.require_code_owner_review
        require_last_push_approval        = each.value.rules.pull_request.require_last_push_approval
        required_approving_review_count   = each.value.rules.pull_request.required_approving_review_count
        required_review_thread_resolution = each.value.rules.pull_request.required_review_thread_resolution
      }
    }
    dynamic "required_deployments" {
      for_each = (each.value.rules.required_deployment_environments != null) ? [1] : []
      content {
        required_deployment_environments = each.value.rules.required_deployment_environments
      }
    }
    required_linear_history = each.value.rules.required_linear_history
    required_signatures     = each.value.rules.required_signatures
    dynamic "required_status_checks" {
      for_each = (each.value.rules.required_status_checks != null) ? [1] : []
      content {
        dynamic "required_check" {
          for_each = each.value.rules.required_status_checks
          content {
            context        = required_check.key
            integration_id = required_check.value
          }
        }
        strict_required_status_checks_policy = each.value.strict_required_status_checks_policy
      }
    }
    dynamic "tag_name_pattern" {
      for_each = try(each.value.rules.tag_name_pattern, null) != null ? [1] : []
      content {
        operator = each.value.rules.tag_name_pattern.operator
        pattern  = each.value.rules.tag_name_pattern.pattern
        name     = each.value.rules.tag_name_pattern.name
        negate   = each.value.rules.tag_name_pattern.negate
      }
    }
    update                        = each.value.rules.update
    update_allows_fetch_and_merge = each.value.rules.update_allows_fetch_and_merge
  }
  target = each.value.target
  dynamic "bypass_actors" {
    for_each = (each.value.bypass_actors != null) ? each.value.bypass_actors : {}
    content {
      actor_id    = bypass_actors.key
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
  dynamic "conditions" {
    for_each = (length(each.value.include) + length(each.value.exclude) > 0) ? [1] : []
    content {
      ref_name {
        include = [for p in each.value.include :
          substr(p, 0, 1) == "~" ? p : format("refs/%s/%s", each.value.target == "branch" ? "heads" : "tags", p)
        ]
        exclude = [for p in each.value.exclude :
          substr(p, 0, 1) == "~" ? p : format("refs/%s/%s", each.value.target == "branch" ? "heads" : "tags", p)
        ]
      }
    }
  }
}

resource "github_issue_labels" "this" {
  count      = try(var.labels, null) != null ? 1 : 0
  repository = github_repository.this.name

  dynamic "label" {
    for_each = var.labels
    content {
      name  = label.key
      color = label.value
    }
  }
}

resource "github_repository_autolink_reference" "this" {
  for_each            = try(var.autolinks, null) != null ? var.autolinks : {}
  repository          = github_repository.this.name
  key_prefix          = each.key
  target_url_template = each.value
  is_alphanumeric     = true
}

resource "github_repository_webhook" "this" {
  for_each   = try(var.webhooks, null) != null ? var.webhooks : {}
  repository = github_repository.this.name
  active     = true
  configuration {
    url          = each.key
    content_type = each.value.content_type
    insecure_ssl = each.value.insecure_ssl
    secret       = each.value.secret
  }
  events = each.value.events
}

resource "github_repository_deploy_key" "this" {
  for_each   = try(var.deploy_keys, null) != null ? var.deploy_keys : {}
  repository = github_repository.this.name
  title      = each.key
  key        = each.value.key != null ? each.value.key : tls_private_key.this[each.key].public_key_openssh
  read_only  = each.value.read_only
}

# auto-generated if the key is not provided
resource "tls_private_key" "this" {
  for_each = try(var.deploy_keys, null) == null ? {} : {
    for name, config in var.deploy_keys : name => config if config.key == null
  }
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "create_subfolder" {
  count = try(var.deploy_keys, null) == null ? 0 : 1
  provisioner "local-exec" {
    command = "mkdir -p ${var.deploy_keys_path}"
  }
}

resource "local_file" "private_key_file" {
  for_each = try(var.deploy_keys, null) == null ? {} : {
    for name, config in var.deploy_keys : name => config if config.key == null
  }
  filename = "${var.deploy_keys_path}/${github_repository.this.name}-${each.key}.pem"
  content  = tls_private_key.this[each.key].private_key_openssh
  depends_on = [
    null_resource.create_subfolder
  ]
}

resource "github_repository_file" "this" {
  for_each            = try(var.files, null) != null ? var.files : {}
  repository          = github_repository.this.name
  file                = each.key
  content             = each.value.path != null ? file(each.value.path) : each.value.content
  branch              = each.value.branch
  commit_author       = each.value.commit != null ? element(split(":", each.value.commit), 0) : null
  commit_email        = each.value.commit != null ? element(split(":", each.value.commit), 1) : null
  commit_message      = each.value.commit != null ? element(split(":", each.value.commit), 2) : null
  overwrite_on_create = each.value.overwrite_on_create
}

resource "github_actions_repository_access_level" "this" {
  count        = try(var.actions_access_level, null) != null ? 1 : 0
  repository   = github_repository.this.name
  access_level = var.actions_access_level
}

resource "github_actions_repository_permissions" "this" {
  count           = try(var.actions_permissions, null) != null ? 1 : 0
  repository      = github_repository.this.name
  enabled         = var.actions_permissions.enabled
  allowed_actions = var.actions_permissions.allowed_actions
  dynamic "allowed_actions_config" {
    for_each = var.actions_permissions.allowed_actions == "selected" ? [1] : []
    content {
      github_owned_allowed = try(var.actions_permissions.allowed_actions_config.github_owned_allowed, null)
      patterns_allowed     = try(var.actions_permissions.allowed_actions_config.patterns_allowed, null)
      verified_allowed     = try(var.actions_permissions.allowed_actions_config.verified_allowed, null)
    }
  }
}

resource "github_actions_secret" "this" {
  for_each        = try(var.secrets, null) != null ? var.secrets : {}
  repository      = github_repository.this.name
  secret_name     = each.key
  encrypted_value = each.value.encrypted_value
  plaintext_value = each.value.plaintext_value
}

resource "github_actions_variable" "this" {
  for_each      = try(var.variables, null) != null ? var.variables : {}
  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value
}

resource "github_repository_environment" "this" {
  for_each            = try(var.environments, null) != null ? var.environments : {}
  repository          = github_repository.this.name
  environment         = each.key
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  prevent_self_review = each.value.prevent_self_review
  dynamic "reviewers" {
    for_each = try(each.value.reviewers, null) != null ? [1] : []
    content {
      teams = reviewers.value.teams
      users = reviewers.value.users
    }
  }
  dynamic "deployment_branch_policy" {
    for_each = try(each.value.deployment_branch_policy, null) != null ? [1] : []
    content {
      protected_branches     = each.value.deployment_branch_policy.protected_branches
      custom_branch_policies = length(each.value.deployment_branch_policy.custom_branch_policies) > 0
    }
  }
}

resource "github_actions_environment_secret" "this" {
  for_each = try(var.environments, null) == null ? {} : {
    for i in flatten([
      for environment in keys(var.environments) : [
        for secret in keys(var.environments[environment].secrets) : {
          environment     = environment
          secret_name     = secret
          encrypted_value = var.environments[environment].secrets[secret].encrypted_value
          plaintext_value = var.environments[environment].secrets[secret].plaintext_value
        }
      ] if var.environments[environment].secrets != null
    ])
    : format("%s:%s", i.environment, i.secret_name) => i
  }
  repository      = github_repository.this.name
  environment     = github_repository_environment.this[each.value.environment].environment
  secret_name     = each.value.secret_name
  encrypted_value = each.value.encrypted_value
  plaintext_value = each.value.plaintext_value
}

resource "github_actions_environment_variable" "this" {
  for_each = try(var.environments, null) == null ? {} : {
    for i in flatten([
      for environment in keys(var.environments) : [
        for variable in keys(var.environments[environment].variables) : {
          environment   = environment
          variable_name = variable
          value         = var.environments[environment].variables[variable]
        }
      ] if var.environments[environment].variables != null
    ])
    : format("%s:%s", i.environment, i.variable_name) => i
  }
  repository    = github_repository.this.name
  environment   = github_repository_environment.this[each.value.environment].environment
  variable_name = each.value.variable_name
  value         = each.value.value
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = try(var.environments, null) == null ? {} : {
    for i in flatten([
      for environment in keys(var.environments) : [
        for branch_pattern in var.environments[environment].deployment_branch_policy.custom_branch_policies : {
          environment    = environment
          branch_pattern = branch_pattern
        }
      ] if var.environments[environment].deployment_branch_policy != null
    ])
    : format("%s:%s", i.environment, i.branch_pattern) => i
  }
  repository     = github_repository.this.name
  environment    = github_repository_environment.this[each.value.environment].environment
  branch_pattern = each.value.branch_pattern
}

module "properties" {
  count      = try(var.properties, null) != null ? 1 : 0
  source     = "./modules/properties"
  repository = github_repository.this.name
  properties = var.properties
}
