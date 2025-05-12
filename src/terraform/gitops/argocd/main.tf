resource "helm_release" "argocd" {
  name             = var.argocd_name
  repository       = var.argocd_repository
  chart            = var.argocd_chart
  namespace        = var.argocd_namespace
  create_namespace = var.argocd_create_namespace
  version          = var.argocd_version
  verify           = var.argocd_verify
  values           = [file("config.yaml")]
}

resource "null_resource" "kubectl_apply" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = "kubectl apply -f git-repo-conf.yaml -n gitops"
  }
}
