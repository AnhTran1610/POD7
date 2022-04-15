# This repo is for demo POD7 architecture


### Apply kubectl: 
```
aws eks --region us-east-1 update-kubeconfig --name <cluster-name>
```
### Initial password for argocd-server:
```  
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Testing