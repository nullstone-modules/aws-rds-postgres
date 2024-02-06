resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/rds/instance/${local.resource_name}/postgresql"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.this.arn
  tags              = local.tags
}

resource "aws_cloudwatch_log_group" "upgrade" {
  name              = "/aws/rds/instance/${local.resource_name}/upgrade"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.this.arn
  tags              = local.tags
}

resource "aws_iam_user" "log_reader" {
  name = "log-reader-${local.resource_name}"
  tags = local.tags
}

resource "aws_iam_access_key" "log_reader" {
  user = aws_iam_user.log_reader.name
}

resource "aws_iam_user_policy" "log_reader" {
  name   = "AllowReadLogsAndMetrics"
  user   = aws_iam_user.log_reader.name
  policy = data.aws_iam_policy_document.log_reader.json
}

data "aws_iam_policy_document" "log_reader" {
  statement {
    sid    = "AllowReadLogs"
    effect = "Allow"

    actions = [
      "logs:Get*",
      "logs:List*",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:TestMetricFilter",
      "logs:Filter*"
    ]

    resources = [
      aws_cloudwatch_log_group.this.arn,
      aws_cloudwatch_log_group.upgrade.arn,
    ]
  }

  statement {
    sid       = "AllowGetMetrics"
    effect    = "Allow"
    resources = ["*"] // Metrics cannot be restricted by resource

    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
    ]
  }
}
