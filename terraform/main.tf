terraform {
  required_version = "~> 0.13.5"

  backend "local" {
    path = "/home/hutson/.local/share/tarraform/dotfiles.tfstate"
  }
}
