resource "aws_cloudwatch_metric_alarm" "shield_ddos_us" {
  provider = aws.us-east-1

  alarm_name          = "${local.csi}_shield_ddos_${replace(regex("[^/]+$", aws_route53_zone.root.name), "/[^a-zA-Z0-9-]/", "-")}"
  alarm_description   = "SHIELD: Triggers when a DDoS attack is detected on ${aws_route53_zone.root.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 20
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    ResourceArn = aws_route53_zone.root.arn
  }
}
