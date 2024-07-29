# Github Repository Terraform module

Terraform module which creates a Github Repository with all (or almost all) features provided by Github provider.

These features of Github Repository configurations are supported:

- visibility
- default branch
- features (wikis, issues, discussions, projects)
- pull requests (merge commits, squash merging, rebase merging, auto-merge)
- access (collaborators and teams)
- rulesets (branch and tag)
- actions (actions and workflow permissions, environments, secrets and variables)
- webhooks
- pages
- security (dependabot, code scanning, secret scanning)
- deploy keys
- renaming repositories (newname)

## Usage

### Private repository

```hcl
module "repo" {
  source = "vmvarela/repository/github"

  name           = "my-repo"
  visibility     = "private"
  default_branch = "main"
  template = {
    owner = "MarketingPipeline"
    repository "Awesome-Repo-Template"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.5 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_properties"></a> [properties](#module\_properties) | ./modules/properties | n/a |

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_repository_access_level.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_repository_access_level) | resource |
| [github_actions_repository_permissions.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_repository_permissions) | resource |
| [github_actions_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch_default.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_issue_labels.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_autolink_reference.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference) | resource |
| [github_repository_collaborators.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators) | resource |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_dependabot_security_updates) | resource |
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_environment_deployment_policy.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment_deployment_policy) | resource |
| [github_repository_file.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_ruleset.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [local_file.private_key_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.create_subfolder](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_permissions"></a> [actions\_permissions](#input\_actions\_permissions) | (Optional) The list of permissions configuration of the repository | <pre>object({<br>    enabled         = optional(bool)<br>    allowed_actions = optional(string)<br>    allowed_actions_config = optional(object({<br>      github_owned_allowed = optional(bool)<br>      patterns_allowed     = optional(list(string))<br>      verified_allowed     = optional(bool)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | (Optional) Set to true to archive the repository instead of deleting on destroy | `bool` | `null` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | (Optional) Specifies if the repository should be archived. Defaults to false. | `bool` | `null` | no |
| <a name="input_autolinks"></a> [autolinks](#input\_autolinks) | (Optional) The list of autolink references of the repository (key: key\_prefix) | `map(string)` | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | (Optional) base branch against which all pull requests and code commits are automatically made unless you specify a different branch | `string` | `null` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | (Optional) The list of deploy keys of the repository (key: key\_title) | <pre>map(object({<br>    key       = optional(string) # auto-generated if not provided<br>    read_only = optional(bool, true)<br>  }))</pre> | `null` | no |
| <a name="input_deploy_keys_path"></a> [deploy\_keys\_path](#input\_deploy\_keys\_path) | (Optional) The path to the generated deploy keys for this repository | `string` | `"./deploy_keys"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the repository | `string` | `null` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | (Optional) The list of environments configuration of the repository (key: environment\_name) | <pre>map(object({<br>    wait_timer          = optional(number)<br>    can_admins_bypass   = optional(bool)<br>    prevent_self_review = optional(bool)<br>    reviewers = optional(object({<br>      users = optional(map(string), {})<br>      teams = optional(map(string), {})<br>    }))<br>    deployment_branch_policy = optional(object({<br>      protected_branches     = optional(bool, false)<br>      custom_branch_policies = optional(list(string), [])<br>    }))<br>    secrets = optional(map(object({<br>      encrypted_value = optional(string)<br>      plaintext_value = optional(string)<br>    })))<br>    variables = optional(map(string))<br>  }))</pre> | `null` | no |
| <a name="input_features"></a> [features](#input\_features) | (Optional) The features of the repository (wiki, issues, discussions, projects) | `list(string)` | `[]` | no |
| <a name="input_files"></a> [files](#input\_files) | (Optional) The list of files of the repository (key: file\_path) | <pre>map(object({<br>    content             = optional(string)<br>    path                = optional(string)<br>    branch              = optional(string)<br>    commit              = optional(string) # format is 'author:email:commit_message'<br>    overwrite_on_create = optional(bool)<br>  }))</pre> | `null` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | (Optional) Set to true if this is a template repository | `bool` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) The list of issue labels of the repository (key: label\_name, value: color) | `map(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the repository | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | (Optional) The repository's GitHub Pages configuration | <pre>object({<br>    source = optional(object({<br>      branch = string<br>      path   = optional(string, "/")<br>    }))<br>    build_type = optional(string, "legacy")<br>    cname      = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_properties"></a> [properties](#input\_properties) | (Optional) The list of properties of the repository (key: property\_name) | `map(string)` | `null` | no |
| <a name="input_pull_requests"></a> [pull\_requests](#input\_pull\_requests) | (Optional) The pull requests configuration of the repository | `any` | <pre>{<br>  "allowed_merge_types": [<br>    "squash",<br>    "rebase",<br>    "commit"<br>  ]<br>}</pre> | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | (Optional) New name for this repository (useful for renaming, but not changing the key of the resource) | `string` | `null` | no |
| <a name="input_reusable_workflows"></a> [reusable\_workflows](#input\_reusable\_workflows) | (Optional) Reusable workflows enabled for organization. Default: false | `bool` | `false` | no |
| <a name="input_rulesets"></a> [rulesets](#input\_rulesets) | (Optional) Repository rules | <pre>map(object({<br>    enforcement = optional(string, "active")<br>    rules = optional(object({<br>      branch_name_pattern = optional(object({<br>        operator = optional(string)<br>        pattern  = optional(string)<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      commit_author_email_pattern = optional(object({<br>        operator = optional(string)<br>        pattern  = optional(string)<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      commit_message_pattern = optional(object({<br>        operator = optional(string)<br>        pattern  = optional(string)<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      committer_email_pattern = optional(object({<br>        operator = optional(string)<br>        pattern  = optional(string)<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      creation         = optional(bool)<br>      deletion         = optional(bool)<br>      non_fast_forward = optional(bool)<br>      pull_request = optional(object({<br>        dismiss_stale_reviews_on_push     = optional(bool)<br>        require_code_owner_review         = optional(bool)<br>        require_last_push_approval        = optional(bool)<br>        required_approving_review_count   = optional(number)<br>        required_review_thread_resolution = optional(bool)<br>      }))<br>      required_deployment_environments     = optional(list(string))<br>      required_linear_history              = optional(bool)<br>      required_signatures                  = optional(bool)<br>      required_status_checks               = optional(map(string))<br>      strict_required_status_checks_policy = optional(bool)<br>      tag_name_pattern = optional(object({<br>        operator = optional(string)<br>        pattern  = optional(string)<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      update                        = optional(bool)<br>      update_allows_fetch_and_merge = optional(bool)<br>    }))<br>    target = optional(string, "branch")<br>    bypass_actors = optional(map(object({<br>      actor_type  = string<br>      bypass_mode = string<br>    })))<br>    include = optional(list(string), [])<br>    exclude = optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (Optional) The list of secrets configuration of the repository (key: secret\_name) | <pre>map(object({<br>    encrypted_value = optional(string)<br>    plaintext_value = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_security"></a> [security](#input\_security) | (Optional) The list of security features enabled for the repository. | `list(string)` | `[]` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | (Optional) The list of collaborators of the repository (teams) | `map(string)` | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | (Optional) Use a template repository to create this resource (owner/repo) | `string` | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Optional) The list of topics of the repository | `list(string)` | `null` | no |
| <a name="input_url"></a> [url](#input\_url) | (Optional) URL of a page describing the project | `string` | `null` | no |
| <a name="input_users"></a> [users](#input\_users) | (Optional) The list of collaborators of the repository (users) | `map(string)` | `{}` | no |
| <a name="input_variables"></a> [variables](#input\_variables) | (Optional) The list of variables configuration of the repository (key: variable\_name) | `map(string)` | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | (Optional) Can be public or private (or internal if your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+) | `string` | `null` | no |
| <a name="input_web_commit_signoff_required"></a> [web\_commit\_signoff\_required](#input\_web\_commit\_signoff\_required) | (Optional) Require contributors to sign off on web-based commits. See more here. Defaults to false | `bool` | `null` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | (Optional) The list of webhooks of the repository (key: webhook\_url) | <pre>map(object({<br>    content_type = string<br>    insecure_ssl = optional(bool, false)<br>    secret       = optional(string)<br>    events       = optional(list(string))<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_info"></a> [info](#output\_info) | The repository info. |
| <a name="output_private_keys"></a> [private\_keys](#output\_private\_keys) | Values of the private keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Victor M. Varela](https://github.com/vmvarela).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/master/LICENSE) for full details.
