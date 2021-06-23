resource "aws_lambda_function" "db_admin" {
  function_name = "${local.resource_name}-db-admin"
  handler       = "exports.handler"
  runtime       = "nodejs14.x"
  tags          = data.ns_workspace.this.tags
  filename      = "db-admin.zip"
  role          = aws_iam_role.db_admin.arn

  environment {
    variables = {
      DB_CONFIG_SECRET_ID = aws_secretsmanager_secret.db_admin_pg.id
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.user.id]
    subnet_ids         = local.private_subnet_ids
  }
}

resource "aws_secretsmanager_secret" "db_admin_pg" {
  name = "${local.resource_name}/db-admin"
  tags = data.ns_workspace.this.tags
}

resource "aws_secretsmanager_secret_version" "db_admin_pg" {
  secret_id = aws_secretsmanager_secret.db_admin_pg.id
  secret_string = jsonencode({
    user : aws_db_instance.this.username,
    host : aws_db_instance.this.address,
    database : "postgres",
    password : random_password.this.result,
    port : aws_db_instance.this.port,
  })
}

resource "aws_iam_role" "db_admin" {
  name               = "${local.resource_name}-db-admin"
  assume_role_policy = data.aws_iam_policy_document.db_admin-assume.json
  tags               = data.ns_workspace.this.tags
}

data "aws_iam_policy_document" "db_admin-assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "db_admin-basic" {
  role       = aws_iam_role.db_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "db_admin-vpc" {
  role       = aws_iam_role.db_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "db_admin" {
  role   = aws_iam_role.db_admin.id
  policy = data.aws_iam_policy_document.db_admin.json
}

data "aws_iam_policy_document" "db_admin" {
  statement {
    sid       = "AllowDbAccess"
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.db_admin_pg.arn]
    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]
  }
}
