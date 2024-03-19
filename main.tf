locals {
  # This local is used to define all required secrets that we have to read from Hashicorp Vault Secrets.
  hcp_vault_secrets = [
    # `hcp_vault_secrets` is a list of object.
    #  Here is an example of an object:
    #  {
    #    app_name = ""
    #    secret   = ""
    #  }
    {
      app_name = "TerraformCloud"
      secret   = "TFC_API_TOKEN"
    }
  ]
}

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
  vulnerability_alerts = true
}

# The following block is used to retrieve secrets and their latest version values for a given application.

data "hcp_vault_secrets_secret" "TFC_API_TOKEN" {
  app_name    = "TerraformCloud"
  secret_name = "manage-modules"
}

resource "github_actions_secret" "this" {
  for_each        = toset(var.modules_name)
  repository      = github_repository.this[each.value].name
  secret_name     = "TFC_API_TOKEN"
  plaintext_value = data.hcp_vault_secrets_secret.TFC_API_TOKEN.secret_value
}

resource "github_branch_protection" "this" {
  for_each                        = toset(var.modules_name)
  repository_id                   = github_repository.this[each.value].name
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

resource "github_team_repository" "modules_contributors" {
  for_each   = toset(var.modules_name)
  team_id    = github_team.this.id
  repository = lower(each.value)
  permission = "push"
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

resource "github_team_repository" "modules_registry_owners" {
  for_each   = toset(var.modules_name)
  team_id    = data.terraform_remote_state.foundation.outputs.modules_registry_github_owners_team
  repository = lower(each.value)
  permission = "push"
}

resource "github_team_repository" "modules_registry_contributors" {
  for_each   = toset(var.modules_name)
  team_id    = data.terraform_remote_state.foundation.outputs.modules_registry_github_contributors_team
  repository = lower(each.value)
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