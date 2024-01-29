# Terraform Cloud Foundation

Code which manages configuration and life-cycle of all the Terraform Cloud
module in the private registry. It is designed to be used from a dedicated
VCS-Driven Terraform Cloud workspace that would provision and manage the
configuration using Terraform code (IaC).

## Permissions

To manage the module in the private registry from that code, provide a token
from an account with `manage modules` access. Alternatively, you can use a
token from a team with that access instead of a user token.

To manage the GitHub resources, provide a token from an account or a GitHub App with
appropriate permissions. It should have:

* Read access to `metadata`
* Read and write access to `administration`, `members` and `code`

## Authentication

### Terraform Cloud

The Terraform Cloud provider requires a Terraform Cloud/Enterprise API token in
order to manage resources.

* Set the `TFE_TOKEN` environment variable: The provider can read the TFE_TOKEN environment variable and the token stored there
to authenticate. Refer to [Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

### GitHub

The GitHub provider requires a GitHub App installation in order to manage resources.

* Set the `GITHUB_APP_ID`, `GITHUB_APP_INSTALLATION_ID`, `GITHUB_APP_PEM_FILE`, and `GITHUB_OWNER`
environment variables. The provider can read the GITHUB_APP_ID, GITHUB_APP_INSTALLATION_ID,
GITHUB_APP_PEM_FILE, and GITHUB_OWNER environment variables to authenticate.

> Because strings with new lines is not support:</br>
> use "\\\n" within the `pem_file` argument to replace new line</br>
> use "\n" within the `GITHUB_APP_PEM_FILE` environment variables to replace new line</br>

## Features

* Manages configuration and life-cycle of GitHub resources:
  * Repository
  * Branch protection
  * Teams
* Manages configuration and life-cycle of Terraform Cloud resources:
  * Private module registry
