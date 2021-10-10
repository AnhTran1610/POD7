provider "helm" {
  kubernetes {
    host                   = module.eksdev.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eksdev.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eksdev.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = kubernetes_service_account.external_dns.metadata.0.namespace
  wait       = true
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = var.external_dns_chart_version

  set {
    name  = "rbac.create"
    value = false
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata.0.name
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "sources"
    value = "{ingress,service}"
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", var.external_dns_domain_filters)}}"
  }

  set {
    name  = "aws.zoneType"
    value = var.external_dns_zoneType
  }

  set {
    name  = "txtOwnerId"
    value = var.hosted_zone_id
  }
  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }
  set {
    name  = "podSecurityContext.runAsUser"
    value = "0"
  }
}
