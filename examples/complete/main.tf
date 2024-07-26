provider "github" {
}

locals {
  defaults     = yamldecode(file("${path.module}/defaults.yaml"))
  repositories = yamldecode(file("${path.module}/repositories.yaml"))
}

module "github" {
  for_each                    = local.repositories
  source                      = "../../"
  name                        = each.key
  repository_name             = try(each.value.repository_name, null)
  deploy_keys_path            = "./keys_pem"
  description                 = try(each.value.description, try(local.defaults.description, null))
  visibility                  = try(each.value.visibility, try(local.defaults.visibility, null))
  url                         = try(each.value.url, try(local.defaults.url, null))
  features                    = try(each.value.features, try(local.defaults.features, null))
  pull_requests               = try(each.value.pull_requests, try(local.defaults.pull_requests, null))
  security                    = try(each.value.security, try(local.defaults.security, null))
  is_template                 = try(each.value.is_template, try(local.defaults.is_template, null))
  web_commit_signoff_required = try(each.value.web_commit_signoff_required, try(local.defaults.web_commit_signoff_required, null))
  archived                    = try(each.value.archived, try(local.defaults.archived, null))
  archive_on_destroy          = try(each.value.archive_on_destroy, try(local.defaults.archive_on_destroy, null))
  topics                      = try(each.value.topics, try(local.defaults.topics, null))
  pages                       = try(each.value.pages, try(local.defaults.pages, null))
  template                    = try(each.value.template, try(local.defaults.template, null))
  default_branch              = try(each.value.default_branch, try(local.defaults.default_branch, null))
  teams                       = try(each.value.teams, try(local.defaults.teams, null))
  users                       = try(each.value.users, try(local.defaults.users, null))
  rulesets                    = try(each.value.rulesets, try(local.defaults.rulesets, null))
  labels                      = try(each.value.labels, try(local.defaults.labels, null))
  autolinks                   = try(each.value.autolinks, try(local.defaults.autolinks, null))
  webhooks                    = try(each.value.webhooks, try(local.defaults.webhooks, null))
  deploy_keys                 = try(each.value.deploy_keys, try(local.defaults.deploy_keys, null))
  files                       = try(each.value.files, try(local.defaults.files, null))
  actions_access_level        = try(each.value.actions_access_level, try(local.defaults.actions_access_level, null))
  actions_permissions         = try(each.value.actions_permissions, try(local.defaults.actions_permissions, null))
  secrets                     = try(each.value.secrets, try(local.defaults.secrets, null))
  variables                   = try(each.value.variables, try(local.defaults.variables, null))
  environments                = try(each.value.environments, try(local.defaults.environments, null))
  properties                  = try(each.value.properties, try(local.defaults.properties, null))
}
