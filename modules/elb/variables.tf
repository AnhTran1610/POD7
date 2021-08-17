variable "namelb"{
    type = string
    default = ""
}
variable "typelb"{
    description = "the value can be application(ALB) or network(NLB)"
    type = string
    default = ""
}
variable "internal"{
    type = bool
    default = "false"
}
variable "subnet_public_ids" {
    type = list(string)
    default = []
}
variable "vpcid" {
    type = string
    default = ""
}