variable "aws_profile" {
  type    = string
  default = "jennings-sandbox"
}
variable "aws_region" {
  type    = string
  default = "us-east-2"
}
variable "private_subnet_id" {
  type    = string
  default = "subnet-28a35f43"
}
variable "nlb_name" {
  type    = string
  default = "test-nlb"
}
variable "nlb_prv_ip" {
  type    = string
  default = "172.31.0.100"
}

variable "delete" {
  type    = bool
  default = true
}