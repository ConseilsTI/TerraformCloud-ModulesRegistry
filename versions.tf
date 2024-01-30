# Configure the minimum required providers supported
terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.51.1"
    }
    github = {
      source  = "integrations/github"
      version = "5.44.0"
    }
  }

  cloud {
    organization = "ConseilsTI"

    workspaces {
      name = "TerraformCloud-ModulesRegistry"
    }
  }

  required_version = "> 1.6.0"

}