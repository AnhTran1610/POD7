### Create IAM Roles for Service Accounts
data "tls_certificate" "this" {
  url = module.eksdev.cluster_identity
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = module.eksdev.cluster_identity
}

data "aws_iam_policy_document" "external-dns-iam-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "external_dns" {
  assume_role_policy = data.aws_iam_policy_document.external-dns-iam-policy.json
  name               = "${module.eksdev.cluster_id}-external-dns"
}

data "aws_iam_policy_document" "external_dns_policy" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "externalDnsPolicy" {
  name   = "${module.eksdev.cluster_id}-external-dns"
  role   = aws_iam_role.external_dns.name
  policy = data.aws_iam_policy_document.external_dns_policy.json
}
