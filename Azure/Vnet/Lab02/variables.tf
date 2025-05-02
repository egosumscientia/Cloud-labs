variable "location" {
  default = "eastus"
}

variable "admin_username" {}
variable "admin_password" {}

variable "subnets" {
  description = "Subnets con NSG y reglas"
}
