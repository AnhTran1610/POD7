variable "nameec2" {
    type = string
    default = ""
}
variable "instance_type" {
    type = string
    default = ""
}
variable "sg_id" {
    type = list(string)
    default = []
}
variable "key_name" {
    type = string
    default = ""
}
variable "PATH_TO_PUBLIC_KEY" {
    type = string
    default = ""
}
variable "subnet_id_private" {
    type = list(string)
    default = []
}
variable "targetgrouparn" {
    type = list(string)
    default = []
}
