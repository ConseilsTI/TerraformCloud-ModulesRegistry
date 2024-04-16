output "repository" {
  description = "Repositories within your GitHub organization."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository }
}

output "full_name" {
  description = "A string of the form \"orgname/reponame\"."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.full_name }
}

output "html_url" {
  description = "URL to the repository on the web."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.html_url }
}

output "ssh_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via SSH."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.ssh_clone_url }
}

output "http_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.http_clone_url }
}

output "git_clone_url" {
  description = "URL that can be provided to git clone to clone the repository anonymously via the git protocol."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.git_clone_url }
}

output "svn_url" {
  description = "URL that can be provided to svn checkout to check out the repository via GitHub's Subversion protocol emulation."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.svn_url }
}

output "node_id" {
  description = "GraphQL global node id for use with v4 API."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.node_id }
}

output "repo_id" {
  description = "GitHub ID for the repository."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.repo_id }
}

output "primary_language" {
  description = "The primary language used in the repository."
  value       = { for github_repository in github_repository.this : github_repository.name => github_repository.primary_language }
}
