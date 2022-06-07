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
  value = {
    for ip, dd in module.ec2_instance:
    ip => ({"private_ip" = dd.private_ip})
  }
  description = "The private IP address of the main server instance."
}