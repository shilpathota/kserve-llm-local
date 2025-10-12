helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# 1) Base CRDs
helm upgrade --install istio-base istio/base -n istio-system --create-namespace

# 2) Control plane (istiod)
helm upgrade --install istiod istio/istiod -n istio-system

# 3) Ingress Gateway (creates Service "istio-ingress")
helm upgrade --install istio-ingress istio/gateway -n istio-system

# Wait for pods + list services
kubectl -n istio-system rollout status deploy/istiod --timeout=180s
kubectl -n istio-system rollout status deploy/istio-ingress --timeout=180s
kubectl -n istio-system get svc
