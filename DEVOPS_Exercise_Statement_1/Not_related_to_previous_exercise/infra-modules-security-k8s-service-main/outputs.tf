output "control_plane_security_group_id" {
  value = aws_security_group.control_plane.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker.id
}

output "load_balancer_security_group_id" {
  value = aws_security_group.load_balancer.id
}

output "control_plane_role_arn" {
  value = aws_iam_role.control_plane.arn
}

output "worker_role_arn" {
  value = aws_iam_role.worker.arn
}

