variable "name_prefix" {
  type        = string
  description = "Globally unique prefix for bucket names (e.g. your alias or account id)"
}

variable "suffix" {
  type        = string
  description = "Short random or env suffix to avoid name clashes"
}

variable "component_names" {
  type        = list(string)
  description = "Logical names, e.g. mimir, loki, tempo"
  default     = ["mimir", "loki", "tempo"]
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
