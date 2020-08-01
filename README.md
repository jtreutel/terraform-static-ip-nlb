# Terraform Module - Network Load Balancer with Configurable Private IP

This Terraform module creates an internal network load balancer in a single subnet with a configurable private IP address.  It was written as a workaround for [missing Terraform functionality](https://github.com/terraform-providers/terraform-provider-aws/issues/11887).  It uses Terraform's `null_resource` resource in conjunction with the AWS CLI to create and destroy the NLB.


### Module Inputs

|Name|Type|Default|Notes|
|---|---|---|---|
|aws_profile|`string`|none|AWS profile used in AWS CLI commands.|
|aws_region|`string`|none|AWS region used in AWS CLI commands.|
|private_subnet_id|`string`|none|ID of private subnet into which the internal NLB is to be deployed.|
|nlb_name|`string`|none|Name of NLB.|
|nlb_private_ip|`string`|none|Desired private IP for NLB.|
|delete|`boolean`|none|Boolean determining whether or not the load balancer should exist `true` ensures that it is created, `false` ensures that it is destroyed.|

### Module Outputs
|Name|Notes|
|---|---|
|aws_cli_stdout|stdout produced by NLB create and destroy commands.|
|nlb_arn|ARN of NLB created by this module.|

### Example Module Declaration

```
module "nlb_static_ipv4" {
  source            = "..."

  aws_profile       = "foobar"
  aws_region        = "us-east-1"
  private_subnet_id = "subnet-1234abcd"
  nlb_name          = "test-nlb"
  nlb_prv_ip        = "10.0.0.200"
  delete            = "false"
}
```




