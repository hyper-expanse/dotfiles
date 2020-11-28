variable "description" {
  default = ""
  type    = string
}

variable "default_branch" {
  default = "main"
  type    = string
}

variable "name" {
  type = string
}

variable "topics" {
  default = []
  type    = set(string)
}
