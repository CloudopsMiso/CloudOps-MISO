variable "project_name" {
  description = "The name of the project"
  type        = string
  default   = "blacklist-service"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "cloudops-miso"
}