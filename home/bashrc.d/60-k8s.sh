# 60-k8s.sh - Kubernetes and related tooling
# Guard: only load if kubectl is available
command -v kubectl >/dev/null 2>&1 || return 0

# Kube context helpers
get_kube_context() {
  local var=$(kubectl config current-context 2>/dev/null)
  echo "${var##*@}"
}

get_kube_namespace() {
  kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo default
}

# Completions
source <(kubectl completion bash)
source <(helm completion bash)
source <(argocd completion bash)

# ArgoCD login wrapper
argocdlogin() {
  argocd login "$1" --grpc-web --grpc-web-root-path /argocd
}

# Netshoot debugging pod
alias netshoot='kubectl run netshoot --rm -i --tty --image=nicolaka/netshoot -- /bin/bash'
