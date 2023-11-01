# Find amis for the Bastion instance.
data "aws_ami" "latest_amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Create the bastion host.
resource "aws_instance" "ldap-host" {
  ami                         = data.aws_ami.latest_amazon_linux_2023.id
  iam_instance_profile        = aws_iam_instance_profile.ldap-host.name
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.ssh_pub_key.key_name
  subnet_id                   = module.vault.bastion_subnet_id
  user_data                   = ""
  # user_data = templatefile("${path.module}/templates/user_data_bastion.sh.tpl",
  #   {
  #     api_addr                           = local.api_addr
  #     vault_ca_cert_path                 = file("${var.vault_ca_cert_path}")
  #     vault_bastion_custom_script_s3_url = var.vault_bastion_custom_script_s3_url
  #     vault_version                      = var.vault_version
  #     vault_package                      = local.vault_package
  #   }
  # )
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.ldap-host.id]
  
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags        = merge({ Name = "ldap-host-${var.vault-name}-${module.vault.random_string}" }, local.tags)
}

resource "aws_security_group" "ldap-host" {
  description = "ldap-host - Traffic to/from the ldap-host"
  name        = "${var.vault-name}-ldap-host"
  vpc_id      = data.terraform_remote_state.def-env.outputs.vpc[0].id
  
  lifecycle {
    create_before_destroy = true
  }
  
  tags        = merge({ Name = "ldap-host-${var.vault-name}-${module.vault.random_string}" }, local.tags)
}

# Make an iam instance profile
resource "aws_iam_instance_profile" "ldap-host" {
  name = "${var.vault-name}-ldap-host"
  role = aws_iam_role.ldap-host.name

  tags = local.tags
}

# Make a role to allow role assumption.
resource "aws_iam_role" "ldap-host" {
  assume_role_policy = data.aws_iam_policy_document.ldap-host.json
  description        = "ldap-host role - ${var.vault-name}"
  name               = "${var.vault-name}-ldap-host"

  tags = local.tags
}

# Make a policy to allow downloading custom scripts from S3.
data "aws_iam_policy_document" "ldap-host" {

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}