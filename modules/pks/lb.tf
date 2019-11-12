// Allow access to PKS API
resource "aws_security_group" "pks_api_lb_security_group" {
  name        = "pks_api_lb_security_group"
  description = "PKS API LB Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 9021
    to_port     = 9021
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = "${merge(var.tags, map("Name", "${var.env_name}-pks-api-lb-security-group"))}"
}

resource "aws_elb" "pks_api" {
  name                             = "${var.env_name}-pks-api-clb"
  availability_zones               = ["${var.availability_zones}"]
  cross_zone_load_balancing        = true
  security_groups                  = [${aws_security_group.pks_api_lb_security_group}]

  listener {
    instance_port = 8443
    instance_protocol = "tcp"
    lb_port = 8443
    lb_protocol = "tcp"
  }
  listener {
    instance_port = 9021
    instance_protocol = "tcp"
    lb_port = 9021
    lb_protocol = "tcp"
  }

  tags = "${var.tags}"
}

// Allow access to the Kubernetes Master node
resource "aws_security_group" "pks_k8s_master_lb_security_group" {
  name        = "pks_k8smaster_lb_security_group"
  description = "PKS K8s Master LB Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = "${merge(var.tags, map("Name", "${var.env_name}-pks-k8smaster-lb"))}"
}

resource "aws_elb" "pks_k8s_master" {
  name                             = "${var.env_name}-pks-k8smaster-clb"
  availability_zones               = ["${var.availability_zones}"]
  cross_zone_load_balancing        = true
  security_groups                  = [${aws_security_group.pks_k8s_master_lb_security_group}]

  listener {
    instance_port = 8443
    instance_protocol = "tcp"
    lb_port = 8443
    lb_protocol = "tcp"
  }

  tags = "${var.tags}"
}