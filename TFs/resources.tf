resource "neon_project" "main" {
  name                      = "Techchallenger - Base"
  org_id                    = var.neon_org_id
  history_retention_seconds = 21600

  lifecycle {
    prevent_destroy = true
  }
}