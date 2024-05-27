variable "vnets" {
  type = map(object({
      address_space = string
      Subnets = list(object({
        name = string
        newbits = number
        netnum = number
      })) 
  }))
}

variable "nsg_count" {
  type = string
     default = 4
}

variable "rules_file" {
    type = string
    default = "rules-20.csv"
  
}

