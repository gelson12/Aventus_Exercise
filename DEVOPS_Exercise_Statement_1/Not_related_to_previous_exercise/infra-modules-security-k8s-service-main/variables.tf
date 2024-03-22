variable "env" {
  type = string
}

variable "network_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "prod_vpc_cidr" {
  type = string
}

variable "security_software_bucket_name" {
  type = string
}

variable "enable_public_ingress" {
  type = bool
}