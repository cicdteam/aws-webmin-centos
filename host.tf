resource "aws_security_group" "host" {
  name = "${var.name}-sg"
  description = "Allow HTTP, HTTPS and SSH traffic"
  vpc_id = "${aws_vpc.infra.id}"
  ingress { # HTTP
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # HTTPS
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # SSH
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # Webmin
      from_port = 10000
      to_port = 10000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "template_file" "host" {
  template = "${file("${path.module}/scripts/hostinit")}"
  vars {
    hostname = "${var.name}"
    domain   = "${var.domain}"
  }
}

resource "aws_instance" "host" {
  ami = "ami-6d1c2007" # Centos7 for us-east-1 region
  instance_type = "${var.instance_type}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.instance_disk}"
  }
  key_name = "${aws_key_pair.infra.key_name}"
  subnet_id = "${aws_subnet.infra.id}"
  tags { Name = "${var.name}.${var.domain}" }
  vpc_security_group_ids = ["${aws_security_group.host.id}"]
  user_data = "${template_file.host.rendered}"
}

resource "aws_eip" "host" {
  instance = "${aws_instance.host.id}"
  vpc = true
}

resource "null_resource" "host_config" {
  connection {
    user         = "centos"
    host         = "${aws_eip.host.public_ip}"
    private_key  = "${file("${var.site_private_key_path}")}"
  }
  provisioner "file" {
    source = "${path.module}/scripts/config.sh"
    destination = "/tmp/config.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/config.sh",
      "/tmp/config.sh ${var.name}.${var.domain} ${var.passwd}",
      "rm -f /tmp/config.sh"
    ]
  }
}
