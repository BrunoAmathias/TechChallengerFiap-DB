terraform {
  required_providers {
    neon = {
      source = "kislerdm/neon"
    }
  }

  backend "s3" {
    bucket       = "fiap-techchallenger"
    key          = "neon/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "neon" {
  api_key = var.neon_api_key
}
