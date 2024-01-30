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