terraform {
  required_providers {
    neon = {
      source = "kislerdm/neon"
    }
  }

  backend "s3" {
    bucket = "fiap-techchallenger"
    key    = "neon/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "neon" {
  # A API key vem da variável de ambiente NEON_API_KEY (não escrever aqui)
}
