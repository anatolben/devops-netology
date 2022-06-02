output "account_id" {
  value = data.aws_caller_identity.current.account_id
  description = "AWS account ID."
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
  description = "AWS user ID"
}

output "region" {
  value = data.aws_region.current.name
  description = "AWS region."
}

output "test_instance_ip_addr" {
  value       = ["${aws_instance.test.*.private_ip}"]
  description = "The private IP address of the main server instance."
}

output "test_instance_subnet" {
  value       = ["${aws_instance.test.*.subnet_id}"]
  description = "VPC Subnet ID to launch in."
}

output "test_1_instance_ip_addr" {
  value       = values(aws_instance.test_1).*.private_ip
  description = "The private IP address of the main server instance."
}

output "test_1_instance_subnet" {
  value       = values(aws_instance.test_1).*.subnet_id
  description = "VPC Subnet ID to launch in."
}
