terraform {
  required_version = "~> 0.12.21"

  backend "local" {
    path = "/home/hutson/.local/share/tarraform/dotfiles.tfstate"
  }
}
