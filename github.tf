terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
provider "github" {
  token = var.github_token
}
resource "github_repository" "sre_scripts" {
    name        = var.repo_name
    description = "Internal scripts for SRE"

    visibility   = "public"
}

locals {
  username = regex("github.com/([^/]+)/", github_repository.sre_scripts.html_url)[0]
}

resource "github_repository_webhook" "pr_merge" {

  repository =  github_repository.sre_scripts.name

  configuration {
    url = aws_lambda_function_url.url.function_url
    content_type = "json"
    insecure_ssl = false
  }

  active = true
  events = ["pull_request","push"]
}
