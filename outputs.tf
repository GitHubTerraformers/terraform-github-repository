output "info" {
  description = "The repository info."
  value       = github_repository.this
}

output "private_keys" {
  description = "Values of the private keys."
  value       = { for key, config in tls_private_key.this : key => config.private_key_pem }
  sensitive   = true
}
