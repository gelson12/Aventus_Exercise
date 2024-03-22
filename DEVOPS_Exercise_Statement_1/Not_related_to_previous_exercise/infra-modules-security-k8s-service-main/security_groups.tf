resource "aws_security_group" "control_plane" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.env}-${var.network_name}-${var.service_name}-control-plane-"

  tags = {
    Name = "${var.env}-${var.network_name}-${var.service_name}-control-plane"
  }
}

resource "aws_security_group_rule" "control_plane_ingress_tls_nodes" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.worker.id
  description              = "TLS (nodes)"
}

resource "aws_security_group_rule" "control_plane_ingress_k8s-api_local" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
  source_security_group_id = aws_security_group.control_plane.id
  description              = "Kubernetes API server (local)"
}

resource "aws_security_group_rule" "control_plane_ingress_k8s-api_nodes" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
  source_security_group_id = aws_security_group.worker.id
  description              = "Kubernetes API server (nodes)"
}

resource "aws_security_group_rule" "control_plane_ingress_etcd-server-client-api" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2379
  to_port                  = 2380
  source_security_group_id = aws_security_group.control_plane.id
  description              = "etcd server client API (local)"
}

resource "aws_security_group_rule" "control_plane_ingress_kubelet-api" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  source_security_group_id = aws_security_group.control_plane.id
  description              = "Kubelet API (local)"
}

resource "aws_security_group_rule" "control_plane_ingress_kube-controller-manager" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 10257
  to_port                  = 10257
  source_security_group_id = aws_security_group.control_plane.id
  description              = "kube-controller-manager (local)"
}

resource "aws_security_group_rule" "control_plane_ingress_kube-scheduler" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 10259
  to_port                  = 10259
  source_security_group_id = aws_security_group.control_plane.id
  description              = "kube-scheduler (local)"
}

resource "aws_security_group_rule" "control_plane_egress_tls" {
  security_group_id = aws_security_group.control_plane.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet TLS outbound"
}

resource "aws_security_group_rule" "control_plane_egress_http" {
  security_group_id = aws_security_group.control_plane.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet HTTP outbound"
}

resource "aws_security_group_rule" "control_plane_egress_kubelet-api" {
  security_group_id        = aws_security_group.control_plane.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  source_security_group_id = aws_security_group.worker.id
  description              = "Kubelet API (nodes)"
}

resource "aws_security_group" "worker" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.env}-${var.network_name}-${var.service_name}-worker-"

  tags = {
    Name = "${var.env}-${var.network_name}-${var.service_name}-worker"
  }
}

resource "aws_security_group_rule" "worker_ingress_http_apps" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 30000
  to_port                  = 32767
  source_security_group_id = aws_security_group.load_balancer.id
  description              = "ALB HTTP"
}

resource "aws_security_group_rule" "worker_ingress_kubelet-api_control-plane" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  source_security_group_id = aws_security_group.control_plane.id
  description              = "Kubelet API (control plane)"
}

resource "aws_security_group_rule" "worker_ingress_kubelet-api_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  source_security_group_id = aws_security_group.worker.id
  description              = "Kubelet API (local)"
}

resource "aws_security_group_rule" "worker_ingress_dns_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 53
  to_port                  = 53
  source_security_group_id = aws_security_group.worker.id
  description              = "DNS (local)"
}

resource "aws_security_group_rule" "worker_ingress_dns-udp_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 53
  to_port                  = 53
  source_security_group_id = aws_security_group.worker.id
  description              = "DNS UDP (local)"
}

resource "aws_security_group_rule" "worker_ingress_datadog-cluster-agent_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5005
  to_port                  = 5005
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog Cluster Agent (local)"
}

resource "aws_security_group_rule" "worker_ingress_datadog-statsd_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 8125
  to_port                  = 8125
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog StatsD (UDP, local)"
}

resource "aws_security_group_rule" "worker_ingress_datadog-apm_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8126
  to_port                  = 8126
  source_security_group_id = aws_security_group.worker.id
  description              = "# Datadog APM (local)"
}

resource "aws_security_group_rule" "worker_ingress_datadog-healthcheck_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5555
  to_port                  = 5555
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog Agent healthcheck (local)"
}

resource "aws_security_group_rule" "worker_egress_k8s-api" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
  source_security_group_id = aws_security_group.control_plane.id
  description              = "Kubernetes API server (control plane)"
}

resource "aws_security_group_rule" "worker_egress_tls" {
  security_group_id = aws_security_group.worker.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet TLS outbound"
}

resource "aws_security_group_rule" "worker_egress_http" {
  security_group_id = aws_security_group.worker.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet HTTP outbound"
}

resource "aws_security_group_rule" "worker_egress_ntp" {
  security_group_id = aws_security_group.worker.id
  type              = "egress"
  protocol          = "udp"
  from_port         = 123
  to_port           = 123
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Internet NTP outbound"
}

resource "aws_security_group_rule" "worker_egress_dns_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 53
  to_port                  = 53
  source_security_group_id = aws_security_group.worker.id
  description              = "DNS (local)"
}

resource "aws_security_group_rule" "worker_egress_dns-udp_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "udp"
  from_port                = 53
  to_port                  = 53
  source_security_group_id = aws_security_group.worker.id
  description              = "DNS UDP (local)"
}

resource "aws_security_group_rule" "worker_egress_datadog-cluster-agent_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5005
  to_port                  = 5005
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog Cluster Agent (local)"
}

resource "aws_security_group_rule" "worker_egress_datadog-statsd_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "udp"
  from_port                = 8125
  to_port                  = 8125
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog StatsD (UDP, local)"
}

resource "aws_security_group_rule" "worker_egress_datadog-apm_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 8126
  to_port                  = 8126
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog APM (local)"
}

resource "aws_security_group_rule" "worker_egress_datadog-healthcheck_local" {
  security_group_id        = aws_security_group.worker.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5555
  to_port                  = 5555
  source_security_group_id = aws_security_group.worker.id
  description              = "Datadog Agent healthcheck (local)"
}

resource "aws_security_group_rule" "worker_egress_datadog-logs" {
  security_group_id = aws_security_group.worker.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 10516
  to_port           = 10516
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Datadog log export (internet)"
}

resource "aws_security_group" "load_balancer" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.env}-${var.network_name}-LOAD-BALANCER-"
  tags = {
    Name = "${var.env}-${var.network_name}-LOAD-BALANCER"
  }
}

resource "aws_security_group_rule" "load_balancer_ingress_tls" {
  count = var.enable_public_ingress ? 1 : 0

  security_group_id = aws_security_group.load_balancer.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS internet traffic"
}

resource "aws_security_group_rule" "load_balancer_egress_http_apps" {
  security_group_id        = aws_security_group.load_balancer.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 30000
  to_port                  = 32767
  source_security_group_id = aws_security_group.worker.id
  description              = "Backend HTTP"
}