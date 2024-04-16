variable "module_names" {
  description = "(Required) A list of module names to published."
  type        = list(string)
  validation {
    condition     = alltrue([for module_name in var.module_names : can(regex("^terraform-[a-zA-Z]+-[a-zA-Z0-9-]+$", module_name))]) ? true : false
    error_message = "Module name must use a three-part name format like `terraform-<PROVIDER>-<NAME>` and contain only alphanumeric and hypens."
  }
}

variable "oauth_client_name" {
  description = "(Required) The name of the OAuth client."
  type        = string
}

variable "organization_name" {
  description = "(Required) The name of the Terraform Cloud organization."
  type        = string
}

variable "tfc_api_token" {
  description = <<EOT
  (Required) The `tfc_api_token` is a block with the following:
    secret_app  : (Optional) The name of the Hashicorp Vault Secrets application where the secret can be found in and can only be used if `value` is not used.
    secret_name : (Optional) The Hashicorp Vault Secrets secret name where the `TFC_API_TOKEN` with permission to managed modules can be found in and can only be used if `value` is not used.
    value       : (Optional) The `TFC_API_TOKEN` with permission to managed modules and can only be used if `secret_app` and `secret_name` are not used.
  EOT
  type = object({
    secret_app  = optional(string, null)
    secret_name = optional(string, null)
    value       = optional(string, null)
  })

  validation {
    condition     = var.tfc_api_token.secret_app != null && var.tfc_api_token.secret_name == null ? false : true
    error_message = "`secret_name` must be defined when `secret_app` is used."
  }
  validation {
    condition     = var.tfc_api_token.secret_app == null && var.tfc_api_token.secret_name != null ? false : true
    error_message = "`secret_app` must be defined when `secret_name` is used."
  }
  validation {
    condition     = var.tfc_api_token.value != null && (var.tfc_api_token.secret_app != null || var.tfc_api_token.secret_name != null) ? false : true
    error_message = "`value`cannot be used when `secret_app` and `secret_name` are used."
  }
}

variable "github_enviromnent_variables" {
  description = <<EOT
  (Optional) The `github_enviromnent_variables` is a list of object block with the following:
    name        : (Required) The environment variable name required to authenticate with GitHub API.
    secret_app  : (Optional) The name of the Hashicorp Vault Secrets application where the secret can be found in and can only be used if `value` is not used.
    secret_name : (Optional) The Hashicorp Vault Secrets secret name where the environment variable can be found in and can only be used if `value` is not used.
    value       : (Optional) The environment variable value required to authenticate with GitHub API and can only be used if `secret_app` and `secret_name` are not used.
  EOT
  type = list(object({
    name        = string
    secret_app  = optional(string, null)
    secret_name = optional(string, null)
    value       = optional(string, null)
  }))
  default = null

  validation {
    condition     = var.github_enviromnent_variables != null ? alltrue([for v in var.github_enviromnent_variables : v.value != null && (v.secret_app != null || v.secret_name != null) ? false : true]) ? true : false : true
    error_message = "`value` cannot be used when `secret_app` and `secret_name` are used."
  }
  validation {
    condition     = var.github_enviromnent_variables != null ? alltrue([for v in var.github_enviromnent_variables : v.secret_app != null && v.secret_name == null ? false : true]) ? true : false : true
    error_message = "`secret_name` must be defined when `secret_app` is used."
  }
  validation {
    condition     = var.github_enviromnent_variables != null ? alltrue([for v in var.github_enviromnent_variables : v.secret_app == null && v.secret_name != null ? false : true]) ? true : false : true
    error_message = "`secret_app` must be defined when `secret_name` is used."
  }
}

variable "teams" {
  description = <<EOT
  (Optional) The `teams` is a list of object block with the following:
    name        : (Required) The name of the team which will have access to every Terraform module.
    create      : (Optional) Whether to create the team.
    description : (Optional) A description of the team.
    permission  : (Optional) The permissions of team members regarding the repository. Valid values are `pull`, `triage`, `push`, `maintain`, `admin`.
  EOT
  type = list(object({
    name        = string
    create      = optional(bool, false)
    description = optional(string, null)
    permission  = optional(string, "pull")
  }))
  default = null

  validation {
    condition     = var.teams != null ? alltrue([for v in var.teams : contains(["pull", "triage", "push", "maintain", "admin"], v.permission) ? true : false]) ? true : false : true
    error_message = "Valid values for `permission` are \"pull\", \"triage\", \"push\", \"maintain\", \"admin\"."
  }
}
