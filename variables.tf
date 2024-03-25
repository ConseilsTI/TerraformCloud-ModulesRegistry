variable "modules_name" {
  description = "(Required) A list of modules name to published."
  type        = list(string)
  validation {
    condition     = alltrue([for module_name in var.modules_name : can(regex("^terraform-[a-zA-Z--]+-[a-zA-Z--]+$", module_name))]) ? true : false
    error_message = "Module name must use a three-part name format like  `terraform-<PROVIDER>-<NAME>` and contain only letters and hypens."
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

variable "github_enviromnent_variables" {
  description = <<EOT
  (Optional) The `github_enviromnent_variables` is a list of object block with the following:
    secret_name  : (Required) The environment variable name required to authenticate with GitHub API.
    secret_app   : (Optional) The name of the Hashicorp Vault Secrets application where the secret can be found in and can only be used if 'value' is not used. 
    secret_value : (Optional) The environment variable value required to authenticate with GitHub API and can only be used if 'app' is not used.
  EOT
  type = list(object({
    secret_name  = string
    secret_app   = optional(string, null)
    secret_value = optional(string, null)
  }))
  default = null

  validation {
    condition     = var.github_enviromnent_variables != null ? alltrue([for v in var.github_enviromnent_variables : v.secret_app != null && v.secret_value != null ? false : true]) ? true : false : true
    error_message = "`secret_app` and `secret_value` cannot be used at the same time."
  }
  validation {
    condition     = var.github_enviromnent_variables != null ? alltrue([for v in var.github_enviromnent_variables : v.secret_app == null && v.secret_value == null ? false : true]) ? true : false : true
    error_message = "`secret_app` or `secret_value` must be used."
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
    condition     = var.teams != null ? alltrue([for v in var.teams : contains(["pull", "triage", "push", "maintain", "admin"], v) ? true : false]) ? true : false : true
    error_message = "Valid values for `permission` are \"pull\", \"triage\", \"push\", \"maintain\", \"admin\"."
  }
}
