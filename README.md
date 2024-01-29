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

* `Administration`: Read and write
* `Content`: Read and write</br>
  *Required, otherwise, allow\_merge\_commit, allow\_rebase\_merge, and allow squash
  merge attributes will be ignored, causing confusing diffs.*
* `Metadata`: Read-only
* `Secrets`: Read and write
* `Iussue`: Read and write

## Authentication

### Terraform Cloud

The Terraform Cloud provider requires a Terraform Cloud/Enterprise API token in
order to manage resources.

* Set the `TFE_TOKEN` environment variable: The provider can read the TFE\_TOKEN environment variable and the token stored there
to authenticate. Refer to [Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

### GitHub

The GitHub provider requires a GitHub token or GitHub App installation in order to manage resources.

There are several ways to provide the required token:

* Set the `token` argument in the provider configuration. You can set the `token` argument in the provider configuration. Use an
input variable for the token.
* Set the `GITHUB_TOKEN` environment variable. The provider can read the `GITHUB_TOKEN` environment variable and the token stored there
to authenticate.

## Features

* Manages configuration and life-cycle of GitHub resources:
  * Repository
  * Branch protection
  * Actions repository permissions
  * Issue label
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

Description: A list of modules name to published.

Type: `list(string)`

### <a name="input_oauth_client_name"></a> [oauth\_client\_name](#input\_oauth\_client\_name)

Description: The name of the OAuth client.

Type: `string`

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: The name of the Terraform Cloud organization.

Type: `string`

## Optional Inputs

No optional inputs.

## Resources

The following resources are used by this module:

- [github_actions_repository_permissions.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/actions_repository_permissions) (resource)
- [github_branch_protection.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/branch_protection) (resource)
- [github_issue_label.bump_version_scheme](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/issue_label) (resource)
- [github_issue_label.major](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/issue_label) (resource)
- [github_issue_label.minor](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/issue_label) (resource)
- [github_issue_label.patch](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/issue_label) (resource)
- [github_repository.this](https://registry.terraform.io/providers/integrations/github/5.44.0/docs/resources/repository) (resource)
- [tfe_registry_module.this](https://registry.terraform.io/providers/hashicorp/tfe/0.51.1/docs/resources/registry_module) (resource)
- [tfe_oauth_client.client](https://registry.terraform.io/providers/hashicorp/tfe/0.51.1/docs/data-sources/oauth_client) (data source)

## Outputs

No outputs.

<!-- markdownlint-enable -->
<!-- markdownlint-disable first-line-h1 -->
------
>This GitHub repository is manage through Terraform Code from [TerraformCloud-Foundation](https://github.com/benyboy84/TerraformCloud-Foundation) repository.
<!-- END_TF_DOCS -->