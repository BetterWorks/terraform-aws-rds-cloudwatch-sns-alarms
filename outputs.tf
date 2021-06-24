output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = var.rds_enabled ? aws_sns_topic.default[0].arn : ""
}

output "sns_topic_name" {
  description = "The Name of the SNS topic"
  value       = var.rds_enabled ? aws_sns_topic.default.name : ""
}
