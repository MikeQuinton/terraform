# Specifying the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_budgets_budget" "aws_budget" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2024-11-28_00:01"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["subscribe@123456.com"]
  }
}