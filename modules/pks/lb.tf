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

  tags = "${merge(var.tags, map("Name", "${var.env_name}-pks-api-clb"))}"
}