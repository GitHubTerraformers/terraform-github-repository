variable "repository" {
  description = "(Required) The name of the repository"
  type        = string
}

variable "properties" {
  description = "(Required) The list of properties of the repository (key: property_name)"
  type        = map(string)
  default     = {}
}
