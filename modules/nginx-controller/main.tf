resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version = "4.2.3"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = join(",", var.subnets)
  }
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  wait_for_load_balancer = true
  metadata {
    name      = "nginx-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                            = "nginx"
      "alb.ingress.kubernetes.io/scheme"                      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                 = "ip"
      "alb.ingress.kubernetes.io/listen-ports"                = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/backend-protocol"            = "HTTP"
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