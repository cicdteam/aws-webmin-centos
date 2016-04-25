output "Webmin endpoint"   { value = "http://${var.name}.${var.domain}:10000" }
output "Webmin credential" { value = "Login: root, Password: ${var.passwd}" }
output "Public IP"         { value = "${aws_eip.host.public_ip}" }