output "ec2_global_ips" {
  value = ["${aws_instance.mini_server.*.public_ip}"]
}