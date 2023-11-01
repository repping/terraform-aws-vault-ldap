# Import the "./default_environment/terraform.tfstate" resources.
data "terraform_remote_state" "def-env" {
  backend = "local"

  config = {
    path = "./default_environment/terraform.tfstate"
  }
} 