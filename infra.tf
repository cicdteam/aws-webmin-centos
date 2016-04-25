provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "infra" {
  cidr_block = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags { Name = "${var.name}-vpc" }
}

resource "aws_subnet" "infra" {
  vpc_id = "${aws_vpc.infra.id}"
  cidr_block = "10.20.30.0/24"
  tags { Name = "${var.name}-subnet" }
  map_public_ip_on_launch = false
}


resource "aws_internet_gateway" "infra" {
  vpc_id = "${aws_vpc.infra.id}"
  tags { Name = "${var.name}-gw" }
}


resource "aws_route_table" "infra" {
  vpc_id = "${aws_vpc.infra.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.infra.id}"
  }
  tags { Name = "${var.name}-routes" }
}

resource "aws_route_table_association" "infra" {
  subnet_id      = "${aws_subnet.infra.id}"
  route_table_id = "${aws_route_table.infra.id}"
}

resource "aws_key_pair" "infra" {
  key_name   = "${var.name}-key"
  public_key = "${file("${var.site_public_key_path}")}"
}
