provider "aws" {
  region = var.region
}


# Data Source to grab current users's account ID
data "aws_caller_identity" "current" {}


# IAM Role Policy allowing "Assume Role" from the current user's account.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "ci-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}


# Using name_prefix to guarantee a unique name
resource "aws_iam_role" "ci-role" {
  name_prefix = "${var.env}-ci-role-"
  assume_role_policy = data.aws_iam_policy_document.ci-role-policy.json
}


resource "aws_iam_user" "ci-user" {
    name = "ci-user1"
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership#argument-reference
resource "aws_iam_user_group_membership" "ci-user-membership" {
  user = aws_iam_user.ci-user.name

  groups = [
    aws_iam_group.ci-group.name,
  ]
}


data "aws_iam_policy_document" "ci-group-policy-json" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.ci-role.arn]
    effect    = "Allow"
  }
}


resource "aws_iam_group_policy" "ci-group-policy" {
  name_prefix = "${var.env}-ci-group-pol-"
  group = aws_iam_group.ci-group.name
  policy = data.aws_iam_policy_document.ci-group-policy-json.json
}


resource "aws_iam_group" "ci-group" {
  name = "${var.env}-ci-group"
}