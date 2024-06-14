output "web_server_public_dns" {
  value = aws_instance.web_server.public_dns
}

output "db_instance_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data_bucket.bucket
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.web_server_logs.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}
