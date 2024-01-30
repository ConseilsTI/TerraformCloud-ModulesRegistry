module "test" {
    source                 = "git::https://github.com/ConseilsTI/terraform-github-repository.git?ref=v1.0.0"
    name                   = "terraform-github-repository-test"
    description            = "This is a test repository"
    delete_branch_on_merge = true
    auto_init              = true
    security_and_analysis = {
      secret_scanning = {
        status = "enabled"
      }
      secret_scanning_push_protection = {
        status = "enabled"
      }
    }
    vulnerability_alerts = true
    allow_update_branch  = false
    branch_protections = [
      {
        pattern                         = "main"
        enforce_admins                  = true
        require_conversation_resolution = true
        required_pull_request_reviews = {
          dismiss_stale_reviews           = true
          require_code_owner_reviews      = true
          required_approving_review_count = "1"
        }
      }
    ]
    actions_secrets = [
      {
        secret_name     = "Secret"
        plaintext_value = "Value"
      },
      {
        secret_name     = "Secret1"
        plaintext_value = "Value"
      },
    ]
    branches = [
      {
        branch = "develop"
      }
    ]
    files = [
      {
        file    = "main.tf"
        content = "# main.tf"
      }
    ]
    }

output "actions_secret" {
  description = "GitHub Actions secrets within your GitHub repository."
  value       = module.test.actions_secret
  sensitive   = true
}

output "actions_secret_created_at" {
  description = "Date of actions_secret creation."
  value       = module.test.actions_secret_created_at
}

output "actions_secret_updated_at" {
  description = "Date of actions_secret update."
  value       = module.test.actions_secret_updated_at
}

output "actions_repository_permissions" {
  description = "GitHub Actions permissions for your repository."
  value       = module.test.actions_repository_permissions
}

output "branches" {
  description = "Branches within your repository."
  value       = module.test.branches
}

output "branches_source_sha" {
  description = "A string storing the commit this branch was started from. Not populated when imported."
  value       = module.test.branches_source_sha
}

output "branches_etag" {
  description = "An etag representing the Branch object."
  value       = module.test.branches_etag
}

output "branches_ref" {
  description = "A string representing a branch reference, in the form of refs/heads/<branch>."
  value       = module.test.branches_ref
}

output "branches_sha" {
  description = "A string storing the reference's HEAD commit's SHA1."
  value       = module.test.branches_sha
}

output "files" {
  description = "Files within your repository."
  value       = module.test.files
}

output "files_commit_sha" {
  description = "The SHA of the commit that modified the file."
  value       = module.test.files_commit_sha
}

output "files_sha" {
  description = "The SHA blob of the file."
  value       = module.test.files_sha
}

output "files_ref" {
  description = "The name of the commit/branch/tag."
  value       = module.test.files_ref
}