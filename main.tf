# resource "aws_cloudwatch_event_target" "sns" {
#   rule       = "${aws_cloudwatch_event_rule.default.name}"
#   target_id  = "SendToSNS"
#   arn        = "${var.sns_topic_arn}"
#   depends_on = ["aws_cloudwatch_event_rule.default"]
#   input      = "${var.sns_message_override}"
# }
data "aws_caller_identity" "default" {
}

# Make a topic
resource "aws_sns_topic" "default" {
  count       = var.enabled ? 1 : 0
  name_prefix = "rds-threshold-alerts"
}

resource "aws_db_event_subscription" "default" {
  count       = var.enabled ? 1 : 0
  name_prefix = "rds-event-sub"
  sns_topic   = aws_sns_topic.default[0].arn

  source_type = "db-instance"
  source_ids  = [var.db_instance_id]

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

  depends_on = [aws_sns_topic_policy.default]
}

resource "aws_sns_topic_policy" "default" {
  count  = var.enabled ? 1 : 0
  arn    = aws_sns_topic.default[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count  = var.enabled ? 1 : 0
  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect    = "Allow"
    resources = [aws_sns_topic.default[0].arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.default.account_id,
      ]
    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.default[0].arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow RDS Event Notification"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.default[0].arn]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

