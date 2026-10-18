# Connection strings de cada serviço. Leia com `terraform output -raw <nome>`
# e cadastre como GitHub Secret (DB_URL / MONGO_URL) no repositório do serviço.

output "os_db_url" {
  description = "DB_URL do OS Service (Neon, database os_db)"
  value       = "postgresql://${neon_role.service["os"].name}:${neon_role.service["os"].password}@${neon_project.main.database_host}/${neon_database.service["os"].name}?sslmode=require"
  sensitive   = true
}

output "billing_db_url" {
  description = "DB_URL do Billing Service (Neon, database billing_db)"
  value       = "postgresql://${neon_role.service["billing"].name}:${neon_role.service["billing"].password}@${neon_project.main.database_host}/${neon_database.service["billing"].name}?sslmode=require"
  sensitive   = true
}

output "execution_mongo_url" {
  description = "MONGO_URL do Execution Service (Atlas M0, database execution_db)"
  value = "${replace(
    mongodbatlas_advanced_cluster.execution.connection_strings.standard_srv,
    "mongodb+srv://",
    "mongodb+srv://${mongodbatlas_database_user.execution.username}:${random_password.execution_db.result}@"
  )}/execution_db?retryWrites=true&w=majority"
  sensitive = true
}
