## Outputs by lambda-testing module

output "lambda_role_name_lambda_testing" {
  value = module.lambda_testing.lambda_role_name
}

output "lambda_role_arn_lambda_testing" {
  value = module.lambda_testing.lambda_role_arn
}

output "iam_policy_arn_lambda_testing" {
  value = module.lambda_testing.iam_policy_arn
}
