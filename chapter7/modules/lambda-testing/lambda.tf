## Creating IAM role so that Lambda can access other AWS
## services as that role.

resource "aws_iam_role" "lambda_role" {
  name = "iam_role_lambda_function"
  assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
          {
              Action    = "sts:AssumeRole"
              Effect    = "Allow"
              Sid       = ""
              Principal = {
                  Service = "lambda.amazonaws.com"
              }
          }
      ]
  })
}

## IAM Policy for Lambda

resource "aws_iam_policy" "lambda_role_policy" {
  name        = "lambda_function_policy"
  description = "IAM Policy for Lambda"
  policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
          {
              Action   = [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ]
              Resource = "arn:aws:logs:*:*:*"
              Effect   = "Allow"
          }
      ]
  })
}

## IAM Policy Attachment

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_role_policy.arn
}

## Generate an archive from content, a file or a directory of files.

data "archive_file" "name" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/"
  output_path = "${path.module}/myzip/python.zip"
}

## Create AWS Lambda

resource "aws_lambda_function" "lambda_func" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "website-health-check"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [
    aws_iam_role_policy_attachment.policy_attach
  ]

  tags = {
      Name    = "Lambda_Func"
      project = "aws-lambda-testing"
  }
}