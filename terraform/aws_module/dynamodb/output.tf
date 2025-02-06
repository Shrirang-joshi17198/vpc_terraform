output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_lock_table.arn
}
