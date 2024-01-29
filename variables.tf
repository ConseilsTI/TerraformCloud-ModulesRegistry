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

variable "team_name" {
  description = "(Required) The name of the team."
  type        = string
}

variable "team_description" {
  description = "(Optional) A description of the team."
  type        = string
  default     = null
}