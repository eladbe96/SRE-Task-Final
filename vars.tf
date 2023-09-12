variable "github_token" {
}

variable "repo_name" {
}

variable "aws_region" {
  default     = "eu-west-3"
}

variable "function_name" {
  default = "github_logger_lambda2"
}
variable "runtime" {
  default = "python3.7"
}

