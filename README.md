# terraform-aws-vault-ldap

A small test environment for Vault with both the LDAP auth and LDAP secrets engine configured.

## How to deploy

1. Create these 3 folders `./tmp`, `./tmp/tls` and `./tmp/ssh`
2. Generate an ssh key for the ec2 instances with `test -f ./tmp/ssh/id_rsa.pub || ssh-keygen -f ./tmp/ssh/id_rsa`
3. Generate self-signed tls certificates for the vault cluster. First make the script executable with `chmod 700 ./generate-tls.sh` and then execute it with `./generate-tls.sh`
4. Rename `./default_environemts/terraform.tfvars.template` to `./default_environemts/terraform.tfvars` and fill in the variables
5. Rename `./terraform.tfvars.template` to `./terraform.tfvars` and fill in the variables. Make sure they match with step 1.
6. Deploy all AWS resources in the `./default_environments` folder with `terraform init` followed by`terraform apply`
7. Deploy all AWS resources in `./` with `terraform init` followed by`terraform apply`
8. Instructions to connect to the Bastion will be output by Terraform once it completes deploying everything in `./`
