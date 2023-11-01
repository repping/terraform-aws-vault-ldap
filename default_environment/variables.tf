variable "region" {
  default     = "eu-central-1"
  description = "The AWS region to use for the deployment."
}
variable "owner" {
  default     = "no owner set"
  description = "Owner of the deployed AWS resources."
}
variable "tags" {
  type = map(string)
  default = {
      name = "value"
    }
  description = "List of generic tags to propogate to all resources that support tags."
}