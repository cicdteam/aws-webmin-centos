output "Webmin_endpoint"   { value = "http://${var.name}.${var.domain}:10000" }
output "Webmin_credential" { value = "Login: root, Password: ${var.passwd}" }
output "Public_IP"         { value = "${aws_eip.host.public_ip}" }