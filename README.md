# This repo is for demo POD7 architecture
### Create keypair: 
```
aws ec2 create-key-pair --key-name theanh --query "KeyMaterial" --output text > theanh.pem
```
### Apply kubectl: 
```
aws eks --region us-east-1 update-kubeconfig --name EKS-NonPROD
```
### Create namespace: 
```
kubectl create namespace argocd
```
### Install Argo CD to cluster: 
```
kubectl -n argocd apply -f ~/test/POD7/argo/argo-cd/install.yml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n argocd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
