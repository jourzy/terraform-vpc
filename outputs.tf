output "public_subnet_ids" {
  description = "ID of the public subnet"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "ID of the private subnet"
  value       = aws_subnet.private[*].id
}

