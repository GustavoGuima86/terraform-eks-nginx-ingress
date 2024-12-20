controller:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    externalTrafficPolicy: Local
  ingressClassResource:
    name: nginx
    enabled: true
    default: true