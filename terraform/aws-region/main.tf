
locals {
   enabled = "${length(concat(var.aws_netserver_azs,  var.aws_flent_azs)) > 0 ? 1 : 0}"
}


resource "aws_vpc" "latency_benchmark" {
  count = "${local.enabled}"
  cidr_block = "10.254.0.0/16"
  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "netbench" {
  count = "${local.enabled}"
  vpc_id = "${aws_vpc.latency_benchmark.id}"

  tags {
    Name = "${var.environment} - Internet Gateway"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "netbench" {
  count = "${local.enabled}"
  vpc_id = "${aws_vpc.latency_benchmark.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.netbench.id}"
  }
}



resource "aws_security_group" "wideopen" {
  count = "${local.enabled}"
  name        = "${var.environment} - wideopen"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.latency_benchmark.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_subnet" "netserver" {
  count = "${length(var.aws_netserver_azs)}"
  vpc_id = "${aws_vpc.latency_benchmark.id}"
  availability_zone = "${var.aws_netserver_azs[count.index]}"
  cidr_block = "10.254.${count.index * 2}.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "netserver" {
    count = "${length(var.aws_netserver_azs)}"
    subnet_id = "${aws_subnet.netserver.*.id[count.index]}"
    route_table_id = "${aws_route_table.netbench.id}"
}

resource "aws_subnet" "flent" {
  count = "${length(var.aws_flent_azs)}"
  vpc_id = "${aws_vpc.latency_benchmark.id}"
  availability_zone = "${var.aws_netserver_azs[count.index]}"
  cidr_block = "10.254.${(count.index + 0.5) * 2}.0/24"
  map_public_ip_on_launch = true
}


data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

// homing to us-east-1, we'll measure from all other regions back to here.
resource "aws_instance" "netserver" {
    count = "${length(var.aws_netserver_azs)}"
    ami = "${data.aws_ami.ubuntu.id}"
    subnet_id = "${aws_subnet.netserver.*.id[count.index]}"
    // 2vcpu, 4gb ram, <=10Gbps, 0.085/hr
    instance_type = "c5.large"
    security_groups = [ "${aws_security_group.wideopen.id}"]
    user_data = "${var.netserver_userdata}"
    tags {
        Service = "netserver"
        Environment = "${var.environment}"
    }
}


resource "aws_instance" "flent" {
    count = "${length(var.aws_flent_azs)}"
    ami = "${data.aws_ami.ubuntu.id}"
    subnet_id = "${aws_subnet.flent.*.id[count.index]}"
    // 2vcpu, 4gb ram, <=10Gbps, 0.085/hr
    instance_type = "c5.large"
    security_groups = [ "${aws_security_group.wideopen.id}"]
    user_data = "${var.flent_userdata}"
    tags {
        Service = "flent"
        Environment = "${var.environment}"
    }
}
