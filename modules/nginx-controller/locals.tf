locals {
  ingress-values = templatefile("${path.module}/values/ingress-values.yaml.tpl", {
  })
}