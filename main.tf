provider "aws" {
  region =var.aws_region
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "main.py"
  output_path = "my_deployment_package.zip"
}


data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "lambda:*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}


resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  filename         = "my_deployment_package.zip"
  source_code_hash = filebase64sha256("my_deployment_package.zip")
  role    = aws_iam_role.lambda_role.arn
  handler = "main.lambda_handler"
  runtime = var.runtime
  environment {
     variables = {
        GIT_PAT = var.github_token
        REPO_NAME = var.repo_name
     }
    }
  }

resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}
