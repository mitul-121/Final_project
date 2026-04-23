
#output "ec2_public_ip" {
 # value = aws_instance.app.public_ip  
#}


output "ec2_public_ip" {
  value = aws_instance.dee_store.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/dee-store-key.pem ec2-user@${aws_instance.dee_store.public_ip}"
}

output "cloudwatch_log_group_app" {
  value = aws_cloudwatch_log_group.app_logs.name
}