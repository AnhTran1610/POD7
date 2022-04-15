helm install my-release bitnami/external-dns --set provider=aws --set domainFilters[0]=cmcloudlab1654.info --set policy=sync --set registry=txt --set txtOwnerId=Z07824011NQQV32KEENMQ --set interval=3m --set rbac.create=true --set rbac.serviceAccountName=my-release-external-dns --set rbac.serviceAccountAnnotations.eks.amazonaws.com/role-arn=arn:aws:iam::412825246027:role/iam_service_account