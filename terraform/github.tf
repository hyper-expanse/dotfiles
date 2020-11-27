provider "github" {
  organization = "hyper-expanse"
  version      = "~> 4.0"
}

module "dotfiles" {
  source = "./modules/github/repository"

  name = "dotfiles"
  topics = [
    "dotfiles",
  ]
}

module "set-npm-auth-token-for-ci" {
  source = "./modules/github/repository"

  name = "set-npm-auth-token-for-ci"
  topics = [
    "automation",
    "ci",
    "npm",
    "npmrc",
    "token",
  ]
}

module "npm-deploy-git-tag" {
  source = "./modules/github/repository"

  name = "npm-deploy-git-tag"
  topics = [
    "deploy",
    "git",
    "npm",
    "tag",
  ]
}

module "conventional-changelog-config" {
  source = "./modules/github/repository"

  name = "conventional-changelog-config"
  topics = [
    "configuration",
    "conventional-changelog",
  ]
}

module "semantic-delivery-gitlab" {
  source = "./modules/github/repository"

  name = "semantic-delivery-gitlab"
  topics = [
    "automation",
    "deliver",
    "gitlab",
  ]
}

module "hyper-expanse_github_io" {
  source = "./modules/github/repository"

  name           = "hyper-expanse.github.io"
  default_branch = "source"
  topics = [
    "blog",
    "website",
  ]
}

module "parse-repository-url" {
  source = "./modules/github/repository"

  name = "parse-repository-url"
  topics = [
    "parser",
    "repository-url",
  ]
}

/*
module "library-release-workflows" {
  source = "./modules/github/repository"

  description = "Library release workflows."
  name        = "library-release-workflows"
  topics = [
    "orb",
  ]
}
*/
