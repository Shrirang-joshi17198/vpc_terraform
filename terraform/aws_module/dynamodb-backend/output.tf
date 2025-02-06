output "table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
}
