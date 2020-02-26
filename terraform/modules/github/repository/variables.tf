variable "description" {
  type    = string
  default = ""
}

variable "default_branch" {
  type    = string
  default = "master"
}

variable "name" {
  type = string
}

variable "topics" {
  type    = set(string)
  default = []
}
