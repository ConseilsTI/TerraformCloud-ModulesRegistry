# The following code block is used to create GitHub team.

resource "github_team" "this" {
  name        = var.team_name
  description = var.team_description
  privacy     = "closed"
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
  topics     = ["terraform", "terraform-module", "terraform-cloud"]
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

data "terraform_remote_state" "foundation" {
  backend = "remote"

  config = {
    organization = "ConseilsTI"
    workspaces = {
      name = "TerraformCloud-Foundation"
    }
  }
}

resource "github_actions_secret" "manage_modules_team_token" {
  for_each        = github_repository.this
  repository      = github_repository.this[each.value.name].name
  secret_name     = "TFC_API_TOKEN"
  plaintext_value = data.terraform_remote_state.foundation.outputs.manage_modules_team_token
}

resource "github_team_repository" "modules_contributors" {
  for_each   = github_repository.this
  team_id    = github_team.this.id
  repository = lower(each.value.name)
  permission = "push"
}

resource "github_team_repository" "modules_registry_owners" {
  for_each   = github_repository.this
  team_id    = data.terraform_remote_state.foundation.outputs.modules_registry_github_owners_team
  repository = lower(each.value.name)
  permission = "push"
}

resource "github_team_repository" "modules_registry_contributors" {
  for_each   = github_repository.this
  team_id    = data.terraform_remote_state.foundation.outputs.modules_registry_github_contributors_team
  repository = lower(each.value.name)
  permission = "push"
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
    module if lower(element(split("-", module), 1)) == "github"
  ])
}

resource "terraform_data" "github_app_id" {
  for_each = toset(local.github_modules)
  triggers_replace = [
    github_repository.this[each.value].id
  ]

  provisioner "local-exec" {
    command = "./scripts/set_test_variables.sh"
    environment = {
      TFC_ORGANIZATION = var.organization_name
      MODULE_PROVIDER  = lower(element(split("-", each.value), 1))
      MODULE_NAME      = "repository"
      TFC_API_TOKEN    = data.terraform_remote_state.foundation.outputs.manage_modules_team_token
      VAR_KEY          = "GITHUB_APP_ID"
      VAR_VALUE        = "288"
    }
  }

  depends_on = [ tfe_registry_module.this ]
}