# The following code block is used to create GitHub team.

resource "github_team" "this" {
  for_each    = { for team in var.teams : team.name => team if team.create }
  name        = each.value.name
  description = each.value.description
  privacy     = "closed"
}

# The following code block is use to get information about GitHub team.

data "github_team" "this" {
  for_each = { for team in var.teams : team.name => team if !team.create }
  slug     = each.value.name
}

# The following code block is used to create GitHub repository.

resource "github_repository" "this" {
  for_each               = toset(var.modules_name)
  name                   = lower(each.value)
  description            = "Terraform module to manage ${element(split("-", each.value), 1)} resources."
  visibility             = "public"
  has_issues             = true
  has_projects           = true
  has_wiki               = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = true
  security_and_analysis {
    # advanced_security {
    #   status = "enabled"
    # }
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
  template {
    owner                = "conseilsti"
    repository           = "terraform-module-template"
    include_all_branches = false
  }
  topics               = ["terraform", "terraform-module", "terraform-cloud"]
  vulnerability_alerts = true
}


resource "github_branch_protection" "this" {
  for_each                        = github_repository.this
  repository_id                   = each.value.name
  pattern                         = "main"
  enforce_admins                  = true
  require_conversation_resolution = true
  # required_status_checks {
  #   strict   = 
  #   contexts = 
  # }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = "0"
  }
}

data "hcp_vault_secrets_secret" "tfc_api_token" {
  count       = var.tfc_api_token.secret_app != null && var.tfc_api_token.secret_name != null ? 1 : 0
  app_name    = var.tfc_api_token.secret_app
  secret_name = var.tfc_api_token.secret_name
}

resource "github_actions_secret" "tfc_api_token" {
  for_each        = github_repository.this
  repository      = github_repository.this[each.value.name].name
  secret_name     = "TFC_API_TOKEN"
  plaintext_value = var.tfc_api_token.value != null ? var.tfc_api_token.value : data.hcp_vault_secrets_secret.tfc_api_token[0].secret_value
}

locals {
  github_team_repository = flatten([for team in var.teams :
    flatten([for repository in github_repository.this :
      merge(
        team,
        {
          repository = repository.name
        }
      )
    ])
  ])
}

resource "github_team_repository" "this" {
  for_each   = { for team_repository in local.github_team_repository : "${team_repository.repository}-${team_repository.name}" => team_repository }
  team_id    = each.value.create ? github_team.this[each.value.name].id : data.github_team.this[each.value.name].id
  repository = each.value.repository
  permission = each.value.permission
}

# The following block is use to get information about an OAuth client.

data "tfe_oauth_client" "client" {
  organization = var.organization_name
  name         = var.oauth_client_name
}

# The following code block is used to create module resources in the private registry.

resource "tfe_registry_module" "this" {
  for_each     = github_repository.this
  organization = var.organization_name
  test_config {
    tests_enabled = true
  }
  vcs_repo {
    display_identifier = each.value.full_name
    identifier         = each.value.full_name
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
    branch             = "main"
  }
}

locals {
  github_modules = flatten([for module in var.modules_name :
    flatten([for variable in var.github_enviromnent_variables :
      merge(
        variable,
        {
          module_name = module
        }
      )
    ]) if lower(element(split("-", module), 1)) == "github"
  ])
}

data "hcp_vault_secrets_secret" "github_module_variables" {
  for_each    = { for module in local.github_modules : module.secret_name => module }
  app_name    = each.value.secret_app
  secret_name = each.value.secret_name
}

resource "terraform_data" "github_module_variables" {
  for_each = { for module in local.github_modules : "${module.module_name}-${module.name}" => module }

  triggers_replace = [
    github_repository.this[each.value.module_name].id
  ]

  provisioner "local-exec" {
    command = "bash ./scripts/set_test_variables.sh"
    environment = {
      TFC_ORGANIZATION = var.organization_name
      MODULE_PROVIDER  = lower(element(split("-", each.value.module_name), 1))
      MODULE_NAME      = substr(each.value.module_name, 17, length(each.value.module_name) - 17)
      TFC_API_TOKEN    = var.tfc_api_token.value != null ? var.tfc_api_token.value : data.hcp_vault_secrets_secret.tfc_api_token[0].secret_value
      VAR_KEY          = each.value.secret_name
      VAR_VALUE        = each.value.value != null ? each.value.value : "${data.hcp_vault_secrets_secret.github_module_variables[each.value.secret_name].secret_value}"
    }
  }

  depends_on = [tfe_registry_module.this]
}
