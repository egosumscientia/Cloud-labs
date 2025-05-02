variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Región para recursos"
  default     = "us-central1"
}

variable "zone" {
  description = "Zona para la instancia"
  default     = "us-central1-a"
}
