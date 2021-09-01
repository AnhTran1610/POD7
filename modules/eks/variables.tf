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
variable "sg_id" {
    type = list(string)
    default = []
}
variable "iam_role_cluster_arn" {
  type = string
  default = ""
}
variable "iam_role_node_arn" {
  type = string
  default = ""
}