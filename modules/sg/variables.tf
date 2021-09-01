variable "namesg" {
    type = string
    default = ""
}
variable "vpcid" {
    type = string
    default = ""
}
variable "cidringress" {
    type = list(string)
    default = ["0.0.0.0/0"]
}
variable "cidregress" {
    type = string
    default = "0.0.0.0/0"
}
variable "fport-ingress" {
    type = number
    default = 0
}
variable "tport-ingress" {
    type = number
    default = 0
}
variable "fport-egress" {
    type = number
    default = 0
}
variable "tport-egress" {
    type = number
    default = 0
}
variable "ptcegress" {
    type = string
    default = "-1"
}
