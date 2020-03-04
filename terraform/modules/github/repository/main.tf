resource "github_repository" "repository" {
  description    = var.description
  default_branch = var.default_branch
  has_downloads  = true
  has_issues     = true
  has_projects   = false
  has_wiki       = false
  name           = var.name
  topics         = var.topics
}

resource "github_branch_protection" "branch_protection" {
  repository             = var.name
  branch                 = var.default_branch
  require_signed_commits = true

  required_status_checks {
    strict = true
  }
}

resource "github_issue_label" "advance-developer-workflow" {
  description = "Issues related to behavior that address a workflow not part of the most common workflow."
  color       = "5843AD"
  name        = "advance developer workflow"
  repository  = var.name
}

resource "github_issue_label" "defect" {
  description = "Functionality not meeting the documented behavior for that project."
  color       = "FF0000"
  name        = "defect"
  repository  = var.name
}

resource "github_issue_label" "design" {
  description = "Discussion around design for behavior that may, or may not, lead to modifications."
  color       = "FADFAE"
  name        = "design"
  repository  = var.name
}

resource "github_issue_label" "documentation" {
  description = "Installation and usage guides, along with how to's for developers, consumers, and contributors."
  color       = "7F8C8D"
  name        = "documentation"
  repository  = var.name
}

resource "github_issue_label" "enhancement" {
  description = "A change to a project's repository that adds new behavior for downstream consumers."
  color       = "69D100"
  name        = "enhancement"
  repository  = var.name
}

resource "github_issue_label" "help-wanted" {
  description = "We need community help to address this issue by contributing a merge request with needed changes."
  color       = "228B22"
  name        = "help wanted"
  repository  = var.name
}

resource "github_issue_label" "operations" {
  description = "Tasks that do not require modifications to a project's repository."
  color       = "00FFFF"
  name        = "operations"
  repository  = var.name
}

resource "github_issue_label" "refactor" {
  description = "A modification to a project's repository that will not change the behavior for downstream consumers."
  color       = "34495E"
  name        = "refactor"
  repository  = var.name
}

resource "github_issue_label" "security" {
  description = "Please file security related issues and incidents as confidential."
  color       = "0033CC"
  name        = "security"
  repository  = var.name
}

resource "github_issue_label" "suggestion" {
  description = "Proposal for a change to the project where concensus may be needed."
  color       = "44AD8E"
  name        = "suggestion"
  repository  = var.name
}

resource "github_issue_label" "support" {
  description = "Issues that do not require modifications to a project, such as questions, guidance, etc."
  color       = "8E44AD"
  name        = "support"
  repository  = var.name
}

resource "github_issue_label" "technical-debt" {
  description = "Task that, if done now, will lower the cost of future work."
  color       = "5843AD"
  name        = "technical debt"
  repository  = var.name
}

resource "github_issue_label" "test" {
  description = "Issues related to a project's test suite, such as unit, integration, or end-to-end tests."
  color       = "F0AD4E"
  name        = "test"
  repository  = var.name
}

resource "github_issue_label" "upstream" {
  description = "Issue can only be resolved by fixing, or enhancing, an upstream dependency."
  color       = "D10069"
  name        = "upstream"
  repository  = var.name
}
