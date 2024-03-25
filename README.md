<!-- BEGIN_TF_DOCS -->
# Terraform Cloud Private Modules Registry

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

To read secrets from Hashicorp Vault Secrets, provide a client ID and a key
from a service principals with the secret `reader` role.

## Authentication

### Terraform Cloud

The Terraform Cloud provider requires a Terraform Cloud/Enterprise API token in
order to manage resources.

* Set the `TFE_TOKEN` environment variable: The provider can read the TFE\_TOKEN environment variable and the token stored there
to authenticate. Refer to [Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

### GitHub

The GitHub provider requires a GitHub App installation in order to manage resources.

* Set the `GITHUB_APP_ID`, `GITHUB_APP_INSTALLATION_ID`, `GITHUB_APP_PEM_FILE`, and `GITHUB_OWNER`
environment variables. The provider can read the GITHUB\_APP\_ID, GITHUB\_APP\_INSTALLATION\_ID,
GITHUB\_APP\_PEM\_FILE, and GITHUB\_OWNER environment variables to authenticate.

> Because strings with new lines is not support:</br>
> use "\\\n" within the `pem_file` argument to replace new line</br>
> use "\n" within the `GITHUB_APP_PEM_FILE` environment variables to replace new line</br>

### Hashicorp Vault Secrets Authentication

The Hashicorp Vault Secrets provider requires a service principal client ID and
a key in order to manage resources.

* Set the `HCP_CLIENT_ID` environment variable: The provider can read the HCP\_CLIENT\_ID
environment variable and the client ID stored there to authenticate. Refer to
[Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

* Set the `HCP_CLIENT_SECRET` environment variable: The provider can read the HCP\_CLIENT\_SECRET
environment variable and the client ID stored there to authenticate. Refer to
[Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

## Features

* Manages configuration and life-cycle of GitHub resources:
  * Repository
  * Branch protection
  * Teams
* Manages configuration and life-cycle of Terraform Cloud resources:
  * Private module registry

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (> 1.6.0)

- <a name="requirement_github"></a> [github](#requirement\_github) (5.44.0)

- <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) (~>0.76)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (0.51.1)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_modules_name"></a> [modules\_name](#input\_modules\_name)

Description: (Required) A list of modules name to published.

Type: `list(string)`

### <a name="input_oauth_client_name"></a> [oauth\_client\_name](#input\_oauth\_client\_name)

Description: (Required) The name of the OAuth client.

Type: `string`

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: (Required) The name of the Terraform Cloud organization.

Type: `string`

### <a name="input_tfc_api_token"></a> [tfc\_api\_token](#input\_tfc\_api\_token)

Description:   (Required) The `tfc_api_token` is a block with the following:  
    secret\_app  : (Optional) The name of the Hashicorp Vault Secrets application where the secret can be found in and can only be used if `value` is not used.  
    secret\_name : (Optional) The Hashicorp Vault Secrets secret name where the `TFC_API_TOKEN` with permission to managed modules can be found in and can only be used if `value` is not used.  
    value       : (Optional) The `TFC_API_TOKEN` with permission to managed modules and can only be used if `secret_app` and `secret_name` are not used.

Type:

```hcl
object({
    secret_app   = optional(string, null)
    secret_name  = optional(string, null)
    value        = optional(string, null)
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_github_enviromnent_variables"></a> [github\_enviromnent\_variables](#input\_github\_enviromnent\_variables)

Description:   (Optional) The `github_enviromnent_variables` is a list of object block with the following:  
    name        : (Required) The environment variable name required to authenticate with GitHub API.  
    secret\_app  : (Optional) The name of the Hashicorp Vault Secrets application where the secret can be found in and can only be used if `value` is not used.  
    secret\_name : (Optional) The Hashicorp Vault Secrets secret name where the environment variable can be found in and can only be used if `value` is not used.  
    value       : (Optional) The environment variable value required to authenticate with GitHub API and can only be used if `secret_app` and `secret_name` are not used.

Type:

```hcl
list(object({
    name        = string
    secret_app  = optional(string, null)
    secret_name = optional(string, null)
    value       = optional(string, null)
  }))
```

Default: `null`

### <a name="input_teams"></a> [teams](#input\_teams)

Description:   (Optional) The `teams` is a list of object block with the following:  
    name        : (Required) The name of the team which will have access to every Terraform module.  
    create      : (Optional) Whether to create the team.  
    description : (Optional) A description of the team.  
    permission  : (Optional) The permissions of team members regarding the repository. Valid values are `pull`, `triage`, `push`, `maintain`, `admin`.

Type:

```hcl
list(object({
    name        = string
    create      = optional(bool, false)
    description = optional(string, null)
    permission  = optional(string, "pull")
  }))
```

Default: `null`

## Resources

The following resources are used by this module:

- [github_actions_secret.manage_modules_team_token](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/actions_secret) (resource)
- [github_branch_protection.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/branch_protection) (resource)
- [github_repository.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/repository) (resource)
- [github_team.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/team) (resource)
- [github_team_repository.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/team_repository) (resource)
- [terraform_data.github_module_variables](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) (resource)
- [tfe_registry_module.this](https://registry.terraform.io/providers/hashicorp/tfe/0.51.1/docs/resources/registry_module) (resource)
- [github_team.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/data-sources/team) (data source)
- [hcp_vault_secrets_secret.github_module_variables](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/vault_secrets_secret) (data source)
- [hcp_vault_secrets_secret.tfc_api_token](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/vault_secrets_secret) (data source)
- [tfe_oauth_client.client](https://registry.terraform.io/providers/hashicorp/tfe/0.51.1/docs/data-sources/oauth_client) (data source)

## Outputs

The following outputs are exported:

### <a name="output_branch_protection"></a> [branch\_protection](#output\_branch\_protection)

Description: GitHub branch protection within your GitHub repository.

### <a name="output_full_name"></a> [full\_name](#output\_full\_name)

Description: A string of the form "orgname/reponame".

### <a name="output_git_clone_url"></a> [git\_clone\_url](#output\_git\_clone\_url)

Description: URL that can be provided to git clone to clone the repository anonymously via the git protocol.

### <a name="output_html_url"></a> [html\_url](#output\_html\_url)

Description: URL to the repository on the web.

### <a name="output_http_clone_url"></a> [http\_clone\_url](#output\_http\_clone\_url)

Description: URL that can be provided to git clone to clone the repository via HTTPS.

### <a name="output_node_id"></a> [node\_id](#output\_node\_id)

Description: GraphQL global node id for use with v4 API.

### <a name="output_primary_language"></a> [primary\_language](#output\_primary\_language)

Description: The primary language used in the repository.

### <a name="output_repo_id"></a> [repo\_id](#output\_repo\_id)

Description: GitHub ID for the repository.

### <a name="output_repository"></a> [repository](#output\_repository)

Description: Repositories within your GitHub organization.

### <a name="output_ssh_clone_url"></a> [ssh\_clone\_url](#output\_ssh\_clone\_url)

Description: URL that can be provided to git clone to clone the repository via SSH.

### <a name="output_svn_url"></a> [svn\_url](#output\_svn\_url)

Description: URL that can be provided to svn checkout to check out the repository via GitHub's Subversion protocol emulation.

<!-- markdownlint-disable first-line-h1 -->
------
>This GitHub repository is manage through Terraform Code from [TerraformCloud-Foundation](https://github.com/ConseilsTI/TerraformCloud-Foundation) repository.
<!-- END_TF_DOCS -->