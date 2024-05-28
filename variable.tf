variable "vnets" {
  type = map(object({
      address_space = string
      Subnets = list(object({
        name = string
        newbits = number
        netnum = number
      })) 
      
  }))
  description = "The virtual network value must not be empty"
}

variable "nsg_count" {
  type = string
     default = 4
     description = "The count value must be in number "
}

variable "rules_file" {
    type = string
    default = "rules-20.csv"
    description = "The rules files must be saved in .csv file name."
  
}

