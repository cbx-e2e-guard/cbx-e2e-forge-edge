output "security_group_id" {
  description = "Id of the database security group."
  value       = aws_security_group.db.id
}
