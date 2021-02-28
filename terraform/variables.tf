variable "env" {
  description = "Environment e.g. 'dev, stg, prd'"
  type        = string
  default     = "prd"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}