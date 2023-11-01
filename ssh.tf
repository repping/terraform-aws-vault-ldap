resource "aws_key_pair" "ssh_pub_key" {
  key_name   = "${var.vault-name}_ssh_pub_key"
  public_key = file("./tmp/ssh/id_rsa.pub")

  tags = local.tags
}
