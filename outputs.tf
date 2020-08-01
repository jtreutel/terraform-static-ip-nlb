output "aws_cli_stdout" {
  value = var.delete == false ? "${data.local_file.log.content}" : "NLB is deleted."
}

output "nlb_arn" {
  value = var.delete == false ? "${trimspace(data.local_file.arn.content)}" : "NLB is deleted."
}