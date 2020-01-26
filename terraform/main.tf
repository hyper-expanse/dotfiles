terraform {
  backend "local" {
    path = "/home/hutson/.local/share/tarraform/dotfiles.tfstate"
  }
}

provider "github" {
  organization = "hyper-expanse"
  version      = "~> 2.3"
}

resource "github_repository" "dotfiles" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "dotfiles"
  topics = [
    "dotfiles",
  ]
}

resource "github_repository" "set-npm-auth-token-for-ci" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "set-npm-auth-token-for-ci"
  topics = [
    "automation",
    "ci",
    "npm",
    "npmrc",
    "token",
  ]
}

resource "github_repository" "npm-deploy-git-tag" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "npm-deploy-git-tag"
  topics = [
    "deploy",
    "git",
    "npm",
    "tag",
  ]
}

resource "github_repository" "conventional-changelog-config" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "conventional-changelog-config"
  topics = [
    "configuration",
    "conventional-changelog",
  ]
}

resource "github_repository" "semantic-delivery-gitlab" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "semantic-delivery-gitlab"
  topics = [
    "automation",
    "deliver",
    "gitlab",
  ]
}

resource "github_repository" "hyper-expanse-github-io" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "hyper-expanse.github.io"
  topics = [
    "blog",
    "website",
  ]
}

resource "github_repository" "parse-repository-url" {
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "parse-repository-url"
  topics = [
    "parser",
    "repository-url",
  ]
}

resource "github_repository" "library-release-workflows" {
  archived      = true
  description   = "Library release workflows."
  has_downloads = true
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  name          = "library-release-workflows"
}
