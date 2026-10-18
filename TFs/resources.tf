resource "neon_project" "main" {
  name                      = "Techchallenger - Base"
  org_id                    = var.neon_org_id
  history_retention_seconds = 21600

  lifecycle {
    prevent_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Neon (PostgreSQL): um database e um role por microsserviço.
# Cada serviço só recebe a connection string do próprio banco.
# ---------------------------------------------------------------------------

locals {
  neon_services = {
    os = {
      role     = "os_service"
      database = "os_db"
    }
    billing = {
      role     = "billing_service"
      database = "billing_db"
    }
  }
}

resource "neon_role" "service" {
  for_each = local.neon_services

  project_id = neon_project.main.id
  branch_id  = neon_project.main.default_branch_id
  name       = each.value.role
}

resource "neon_database" "service" {
  for_each = local.neon_services

  project_id = neon_project.main.id
  branch_id  = neon_project.main.default_branch_id
  name       = each.value.database
  owner_name = neon_role.service[each.key].name
}

# ---------------------------------------------------------------------------
# MongoDB Atlas (NoSQL): cluster M0 gratuito do Execution Service.
# ---------------------------------------------------------------------------

resource "mongodbatlas_project" "main" {
  name   = "techchallenger"
  org_id = var.atlas_org_id
}

resource "mongodbatlas_advanced_cluster" "execution" {
  project_id   = mongodbatlas_project.main.id
  name         = "execution-cluster"
  cluster_type = "REPLICASET"

  replication_specs = [
    {
      region_configs = [
        {
          provider_name         = "TENANT"
          backing_provider_name = "AWS"
          region_name           = var.atlas_region
          priority              = 7

          electable_specs = {
            instance_size = "M0"
          }
        }
      ]
    }
  ]
}

resource "random_password" "execution_db" {
  length  = 32
  special = false
}

resource "mongodbatlas_database_user" "execution" {
  project_id         = mongodbatlas_project.main.id
  username           = "execution_service"
  password           = random_password.execution_db.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "execution_db"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.execution.name
    type = "CLUSTER"
  }
}

resource "mongodbatlas_project_ip_access_list" "allowed" {
  for_each = toset(var.atlas_allowed_cidrs)

  project_id = mongodbatlas_project.main.id
  cidr_block = each.value
  comment    = "Acesso dos servicos (EKS e CI)"
}
