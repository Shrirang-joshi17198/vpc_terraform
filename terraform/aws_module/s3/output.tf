output "s3_bucket_id" {
  value = aws_s3_bucket.my_s3_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.my_s3_bucket.arn
}
