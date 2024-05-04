variable "profile" {
	type = string
	default = "latam"
}

variable "region" {
	type = string
	description = "Region"
	default = "us-east-1"
}

variable "vpc_cidr" {
	type = string
	default = "10.120.0.0/16"
}

variable "app_priv_subnets" {
  type = map
  default = {
		us-east-1a = "10.120.10.0/24"
		us-east-1b = "10.120.11.0/24"
		us-east-1c = "10.120.12.0/24"
  	}
}

variable "db_priv_subnets" {
  type = map
  default = {
		us-east-1a = "10.120.20.0/24"
		us-east-1b = "10.120.21.0/24"
		us-east-1c = "10.120.22.0/24"
  	}
}