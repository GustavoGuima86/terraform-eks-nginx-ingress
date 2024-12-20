
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version = "4.2.3"

  values = [local.ingress-values]
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  wait_for_load_balancer = true
  metadata {
    name      = "nginx-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path     = "/service1"
          path_type = "Prefix"

          backend {
            service {
              name = "service-1"
              port {
                number = 80
              }
            }
          }
        }
        path {
          path     = "/service2"
          path_type = "Prefix"

          backend {
            service {
              name = "service-2"
              port {
                number = 80
              }
            }
          }
        }

      }
    }
  }
  depends_on = [helm_release.ingress_nginx]
}