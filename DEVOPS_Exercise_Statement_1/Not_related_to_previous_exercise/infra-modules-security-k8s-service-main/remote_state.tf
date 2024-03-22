data "terraform_remote_state" "infra-network" {
  backend = "s3"
  config = {
    bucket = "118-tf-state-${var.env}"
    key    = "state/${var.env}/infra-network-${var.network_name}"
    region = "eu-west-1"
  }
}