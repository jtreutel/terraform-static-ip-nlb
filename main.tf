# Runs an AWS CLI command to create the NLB based on var.delete
resource "null_resource" "create_nlb" {
  count = var.delete == false ? 1 : 0
  provisioner "local-exec" {
    command = "aws elbv2 create-load-balancer --name ${var.nlb_name} --type network --scheme internal --subnet-mappings SubnetId=${var.private_subnet_id},PrivateIPv4Address=${var.nlb_prv_ip} --tags Key=environment,Value=sbx --profile ${var.aws_profile}  --region ${var.aws_region} > ${data.template_file.log_path.rendered}"
  }
}

# Provides a path for logging CLI command output to a file
data "template_file" "log_path" {
  template = "${path.module}/output.log"
}

# Runs an AWS CLI command to delete the NLB based on var.delete
# The test for whether the NLB was actually deleted could be made more robust using exit codes and describe-load-balancers
resource "null_resource" "delete_nlb" {
  count = var.delete == true ? 1 : 0
  provisioner "local-exec" {
    command = "if (aws elbv2  delete-load-balancer --load-balancer-arn ${trimspace(data.local_file.arn.content)}  --profile ${var.aws_profile} --region ${var.aws_region}); then echo \"NLB has been deleted.\"; else echo \"Error deleting NLB.\"; fi > ${data.template_file.log_path.rendered}"
  }
  depends_on = [null_resource.create_nlb]
}


# Runs an AWS CLI command to grab the ARN of the NLB.  Triggered whenever the var.delete is changed.
# This means that the command will fail when var.delete == true since the NLB will not exist, causing the 
# AWS CLI command to return an error.  For now, I've added the on_failure attribute to prevent this from stopping the
# TF plan, but there's probably a cleverer way to handle this.
resource "null_resource" "output_nlb_arn" {
  triggers = {
    delete_flag = var.delete
  }  
  provisioner "local-exec" {
    command = "aws elbv2 describe-load-balancers --name ${var.nlb_name} --profile ${var.aws_profile}  --region ${var.aws_region} --query 'LoadBalancers[0].LoadBalancerArn' > ${data.template_file.arn_path.rendered}"
    on_failure = continue
  }
  depends_on = [null_resource.create_nlb]
}

# Provides a path for logging ARN to a file
data "template_file" "arn_path" {
  template = "${path.module}/arn.log"
}

# Provides a data source pointing the file created by null_resource.create_nlb and null_resource.delete_nlb
# This allows us to read the contents of the file in order to output the stdout produced by those commands.
data "local_file" "log" {
  filename   = data.template_file.arn_path.rendered
  depends_on = [null_resource.output_nlb_arn]
}

# Provides a data source pointing the file created by null_resource.output_nlb_arn
# This allows us to read the contents of the file in order to output the ARN.
data "local_file" "arn" {
  filename   = data.template_file.arn_path.rendered
  depends_on = [null_resource.output_nlb_arn]
}



