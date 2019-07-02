provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_key_pair" "btsol" {
  key_name   = "btsol"
  public_key = "${file(var.public_key_path)}"
}


resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "btsol"
  }
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_security_group" "btsol-web" {
  name        = "btsol-web-sg"
  description = "btsol-web-sg"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "btsol-web"
  }
}

resource "aws_security_group" "btsol-db" {
  name        = "btsol-db-sg"
  description = "btsol-db-sg"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.btsol-web.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "btsol-db"
  }
}


resource "aws_instance" "web" {
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }
  ami = "ami-024a64a6685d05041"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.btsol.key_name}"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.btsol-web.id}"]
  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
    ]
  }
  tags = {
    Name = "btsol-web"
  }
}

resource "aws_instance" "db" {
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }
  ami = "ami-024a64a6685d05041"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.btsol.key_name}"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.btsol-db.id}"]
  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
    ]
  }
  tags = {
    Name = "btsol-db"
  }
}


resource "aws_instance" "monitor" {
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }
  ami = "ami-024a64a6685d05041"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.btsol.key_name}"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.btsol-web.id}"]
  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
    ]
  }
  tags = {
    Name = "btsol-monitor"
  }
}

