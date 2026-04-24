resource "aws_cloudwatch_event_rule" "shield_alarms_us" {
  count       = var.csoc_log_forwarding ? 1 : 0
  provider    = aws.us-east-1
  name        = "${local.csi}-shield-alarms-us"
  description = "Forwards AWS Shield DDoS alarms to Custom Event Bus in CSOC Account"

  event_pattern = jsonencode({
    "source"      = ["aws.cloudwatch"],
    "detail-type" = ["CloudWatch Alarm State Change"],
    "detail" = {
      "configuration" = {
        "description" = [
          {
            "prefix" = "SHIELD"
          }
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "shield_alarms_us" {
  count    = var.csoc_log_forwarding ? 1 : 0
  provider = aws.us-east-1
  rule     = aws_cloudwatch_event_rule.shield_alarms_us[0].name
  arn      = local.csoc_shield_bus_arn
  role_arn = aws_iam_role.shield_alarms_us[0].arn
}

resource "aws_iam_role" "shield_alarms_us" {
  count    = var.csoc_log_forwarding ? 1 : 0
  provider = aws.us-east-1
  name     = "${local.csi}-shield-alarms-us"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "shield_alarms_us" {
  count    = var.csoc_log_forwarding ? 1 : 0
  provider = aws.us-east-1
  name     = "${local.csi}-shield-alarms-us"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "events:PutEvents",
      Resource = local.csoc_shield_bus_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "shield_alarms_us" {
  count      = var.csoc_log_forwarding ? 1 : 0
  provider   = aws.us-east-1
  role       = aws_iam_role.shield_alarms_us[0].name
  policy_arn = aws_iam_policy.shield_alarms_us[0].arn
}
