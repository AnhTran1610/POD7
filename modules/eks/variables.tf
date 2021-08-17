variable "namecluster" {
    type = string
    default = ""
}
variable "namenodegroup"{
    type = string
    default = ""
}
variable "allsubnetid" {
    type = list(string)
    default = []
}
variable "allsubnetprivateid"{
    type = list(string)
    default = []
}
variable "k8sversion"{
    type = string
    default = ""
}