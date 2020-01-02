variable "number" {
  type        = number
  description = "How many todos to create in each series"
  default     = 5
}

variable "purpose" {
  type        = string
  description = "The purpose of these todos (dev, test, prod, etc.)"
}

variable "team_name" {
  type        = string
  description = "The name of the team who created the todos"
}

variable "descriptions" {
  type        = list(string)
  description = "A list of default descriptions"
  default     = ["first completed test todo",
                 "second completed test todo",
                 "third completed test todo",
                 "fourth completed test todo",
                 "fifth completed test todo"
                ]
}
