variable "region" {
  default     = "eu-central-1"
  description = "The AWS region to use for the deployment."
}
variable "owner" {
  default     = "no owner set"
  description = "Owner of the deployed AWS resources."
}
variable "vault-name" {
  default     = "vault"
  description = "Name of the Vault deployment. Together with the domain it creates the FQDN."
}
variable "tags" {
  type = map(string)
  default = {
      name = "value"
    }
  description = "List of generic tags to propogate to all resources that support tags."
}