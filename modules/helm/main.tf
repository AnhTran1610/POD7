provider "kubernetes" {
  host                   = var.hosturl
  cluster_ca_certificate = base64decode(var.ca_cer)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", var.clustername]
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "argocd"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.hosturl
    cluster_ca_certificate = base64decode(var.ca_cer)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.clustername]
      command     = "aws"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version = "3.17.5"
  namespace  = "argocd"

  values = [
    file("./charts/argo-cd/values.yaml")
  ]
}
