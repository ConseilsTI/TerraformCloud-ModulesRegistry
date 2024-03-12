<!-- BEGIN_TF_DOCS -->
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

### <a name="input_team_name"></a> [team\_name](#input\_team\_name)

Description: (Required) The name of the team.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_team_description"></a> [team\_description](#input\_team\_description)

Description: (Optional) A description of the team.

Type: `string`

Default: `null`

## Resources

The following resources are used by this module:

- [github_branch_protection.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/branch_protection) (resource)
- [github_repository.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/repository) (resource)
- [github_team.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/team) (resource)
- [github_team_repository.modules-contributors](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/team_repository) (resource)
- [tfe_registry_module.this](https://registry.terraform.io/providers/hashicorp/tfe/0.51.1/docs/resources/registry_module) (resource)
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
>This GitHub repository is manage through Terraform Code from [TerraformCloud-Foundation](https://github.com/benyboy84/TerraformCloud-Foundation) repository.
<!-- END_TF_DOCS -->