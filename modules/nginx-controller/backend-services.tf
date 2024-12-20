resource "helm_release" "service_1" {
  name       = "service-1"
  namespace  = "default"
  chart      = "${path.module}/values/nginx-helm-chart"

  values = [
    <<EOF
fullnameOverride: "service-1"
replicaCount: 2
ingress:
  enabled: false
  hostname: "nginx.example.com"
pageContent: |-
  <!DOCTYPE html>
  <html>
  <head>
      <title>Custom Page</title>
  </head>
  <body>
      <h1>Hello from Service 1!</h1>
      <p>Congrats, you are visiting service 1.</p>
  </body>
  </html>
EOF
  ]
}


resource "helm_release" "service_2" {
  name       = "service-2"
  namespace  = "default"
  chart      = "${path.module}/values/nginx-helm-chart"

  values = [
    <<EOF
fullnameOverride: "service-2"
replicaCount: 2
ingress:
  enabled: false
  hostname: "nginx.example.com"
pageContent: |-
  <!DOCTYPE html>
  <html>
  <head>
      <title>Custom Page</title>
  </head>
  <body>
      <h1>Hello from Service 2!</h1>
      <p>Congrats, you are visiting service 2.</p>
  </body>
  </html>
EOF
  ]
}