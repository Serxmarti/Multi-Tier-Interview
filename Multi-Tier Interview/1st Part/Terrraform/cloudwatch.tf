resource "aws_cloudwatch_log_group" "web_server_logs" {
  name              = "web-server-logs"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "web_server_log_stream" {
  name           = "web-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.web_server_logs.name
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_access_alarm" {
  alarm_name          = "S3UnauthorizedAccess"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnauthorizedAccessAttempts"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    BucketName = aws_s3_bucket.app_data_bucket.bucket
  }
}

resource "aws_cloudwatch_metric_alarm" "bucket_policy_changes_alarm" {
  alarm_name          = "S3BucketPolicyChanges"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketPolicyChanges"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    BucketName = aws_s3_bucket.app_data_bucket.bucket
  }
}

resource "aws_cloudwatch_metric_alarm" "unusual_data_access_alarm" {
  alarm_name          = "S3UnusualDataAccess"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnusualDataAccessPatterns"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    BucketName = aws_s3_bucket.app_data_bucket.bucket
  }
}

resource "aws_sns_topic" "alarm_topic" {
  name = "alarm-topic"
}
