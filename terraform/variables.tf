# variables.tf

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# Define a variable for the cohort number with a default value
variable "cohort_number" {
  description = "Cohort number to tag resources"
  type        = string
  default     = "c500"
}
