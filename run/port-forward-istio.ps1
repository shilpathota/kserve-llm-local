# Choose a free port (18080 avoids collisions with other tools)
kubectl -n istio-system port-forward svc/istio-ingress 18080:80
