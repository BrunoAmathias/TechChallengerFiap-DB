terraform {
  required_providers {
    neon = {
      source = "kislerdm/neon"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 2.18.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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

# Credenciais: atlas_public_key/atlas_private_key (secrets.auto.tfvars, uso
# local) ou, se ficarem nulas, as variáveis de ambiente MONGODB_ATLAS_PUBLIC_KEY
# e MONGODB_ATLAS_PRIVATE_KEY (usadas no CI/CD).
provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}
