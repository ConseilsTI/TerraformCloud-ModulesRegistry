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

variable "team_contributors" {
  description = <<EOT
  (Optional) The team_contributor block supports the following:
    name        : (Required) The name of the team.
    description : (Optional) A description of the team.
  EOT
  type = object({
    name        = string
    description = optional(string, null)
  })
  default = {
    name        = "TerraformCloud-Modules-Contrinutors"
    description = "Team to grant `write` access to all Terraform modules."
  }
}

variable "team_owners" {
  description = <<EOT
  (Required) The team_owners block supports the following:
    name        : (Required) The name of the team.
    description : (Optional) A description of the team.
  EOT
  type = object({
    name        = string
    description = optional(string, null)
  })
  default = {
    name        = "TerraformCloud-Modules-Owners"
    description = "Team to grant `admin` access to all Terraform modules and `owner`for any files in the /.github/workflows/ directory."
  }
}