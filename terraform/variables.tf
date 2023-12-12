variable "environment" {
  type = string
  default = "rabbit"
}
variable "region" {
  type = string
  default = "eu-west-1"
}

variable "public_subnets_cidr" {
  type = list(any)
  default = ["10.10.0.0/24","10.10.1.0/24"]
}
variable "private_subnets_cidr" {
  type = list(any)
  default = ["10.10.2.0/24","10.10.3.0/24"]
}
variable "availability_zones" {
  type = list(any)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
