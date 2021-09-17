variable "aws_profile" {
  description = "The name of AWS Profile"
  default     = "default"
}

variable "aws_credentials_path" {
  description = "The name of AWS Credentials Path"
  default     = "~/.aws/credentials"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-1"
}

variable "aws_availability_1" {
  description = "AWS Availability 1"
  default     = "eu-west-1a"
}

variable "aws_availability_2" {
  description = "AWS Availability 2"
  default     = "eu-west-1b"
}
