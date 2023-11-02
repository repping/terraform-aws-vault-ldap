# Import the "./default_environment/terraform.tfstate" resources.
data "terraform_remote_state" "def-env" {
  backend = "local"

  config = {
    path = "./default_environment/terraform.tfstate"
  }
} 

data "aws_vpc" "default" {
  id = data.terraform_remote_state.def-env.outputs.vpc[0].id
}
