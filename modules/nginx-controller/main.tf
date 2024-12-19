
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version = "4.2.3"

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb" # Use Network Load Balancer
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    externalTrafficPolicy: Local
  ingressClassResource:
    name: nginx
    enabled: true
    default: true
EOF
  ]
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