provider "github" {
  owner = var.owner
}

locals {
  defaults     = yamldecode(file("${path.module}/defaults.yaml"))
  repositories = yamldecode(file("${path.module}/repositories.yaml"))
}

module "github" {
  for_each = local.repositories
  source   = "../../"
  # source                                  = "github.com/vmvarela/terraform-github-repository?ref=v0.1.0"
  name                                    = each.key
  deploy_keys_path                        = "./keys_pem"
  description                             = try(each.value.description, try(local.defaults.description, null))
  visibility                              = try(each.value.visibility, try(local.defaults.visibility, null))
  homepage_url                            = try(each.value.homepage_url, try(local.defaults.homepage_url, null))
  has_issues                              = try(each.value.has_issues, try(local.defaults.has_issues, null))
  has_discussions                         = try(each.value.has_discussions, try(local.defaults.has_discussions, null))
  has_projects                            = try(each.value.has_projects, try(local.defaults.has_projects, null))
  has_wiki                                = try(each.value.has_wiki, try(local.defaults.has_wiki, null))
  is_template                             = try(each.value.is_template, try(local.defaults.is_template, null))
  allow_merge_commit                      = try(each.value.allow_merge_commit, try(local.defaults.allow_merge_commit, null))
  allow_squash_merge                      = try(each.value.allow_squash_merge, try(local.defaults.allow_squash_merge, null))
  allow_rebase_merge                      = try(each.value.allow_rebase_merge, try(local.defaults.allow_rebase_merge, null))
  allow_auto_merge                        = try(each.value.allow_auto_merge, try(local.defaults.allow_auto_merge, null))
  squash_merge_commit_title               = try(each.value.squash_merge_commit_title, try(local.defaults.squash_merge_commit_title, null))
  squash_merge_commit_message             = try(each.value.squash_merge_commit_message, try(local.defaults.squash_merge_commit_message, null))
  merge_commit_title                      = try(each.value.merge_commit_title, try(local.defaults.merge_commit_title, null))
  merge_commit_message                    = try(each.value.merge_commit_message, try(local.defaults.merge_commit_message, null))
  delete_branch_on_merge                  = try(each.value.delete_branch_on_merge, try(local.defaults.delete_branch_on_merge, null))
  web_commit_signoff_required             = try(each.value.web_commit_signoff_required, try(local.defaults.web_commit_signoff_required, null))
  auto_init                               = try(each.value.auto_init, try(local.defaults.auto_init, null))
  gitignore_template                      = try(each.value.gitignore_template, try(local.defaults.gitignore_template, null))
  license_template                        = try(each.value.license_template, try(local.defaults.license_template, null))
  archived                                = try(each.value.archived, try(local.defaults.archived, null))
  archive_on_destroy                      = try(each.value.archive_on_destroy, try(local.defaults.archive_on_destroy, null))
  topics                                  = try(each.value.topics, try(local.defaults.topics, null))
  vulnerability_alerts                    = try(each.value.vulnerability_alerts, try(local.defaults.vulnerability_alerts, null))
  ignore_vulnerability_alerts_during_read = try(each.value.ignore_vulnerability_alerts_during_read, try(local.defaults.ignore_vulnerability_alerts_during_read, null))
  allow_update_branch                     = try(each.value.allow_update_branch, try(local.defaults.allow_update_branch, null))
  pages                                   = try(each.value.pages, try(local.defaults.pages, null))
  security_and_analysis                   = try(each.value.security_and_analisys, try(local.defaults.security_and_analisys, null))
  template                                = try(each.value.template, try(local.defaults.template, null))
  default_branch                          = try(each.value.default_branch, try(local.defaults.default_branch, null))
  collaborators                           = try(each.value.collaborators, try(local.defaults.collaborators, null))
  rulesets                                = try(each.value.rulesets, try(local.defaults.rulesets, null))
  issue_labels                            = try(each.value.issue_labels, try(local.defaults.issue_labels, null))
  autolink_references                     = try(each.value.autolink_references, try(local.defaults.autolink_references, null))
  webhooks                                = try(each.value.webhooks, try(local.defaults.webhooks, null))
  deploy_keys                             = try(each.value.deploy_keys, try(local.defaults.deploy_keys, null))
  files                                   = try(each.value.files, try(local.defaults.files, null))
  actions_access_level                    = try(each.value.actions_access_level, try(local.defaults.actions_access_level, null))
  actions_permissions                     = try(each.value.actions_permissions, try(local.defaults.actions_permissions, null))
  secrets                                 = try(each.value.secrets, try(local.defaults.secrets, null))
  variables                               = try(each.value.variables, try(local.defaults.variables, null))
  environments                            = try(each.value.environments, try(local.defaults.environments, null))
  dependabot_security_updates             = try(each.value.dependabot_security_updates, try(local.defaults.dependabot_security_updates, null))
  properties                              = try(each.value.properties, try(local.defaults.properties, null))
}
