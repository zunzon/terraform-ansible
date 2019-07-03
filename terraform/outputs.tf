output "NginxIps" {
  value = "${aws_instance.web.public_ip}"
}


output "DBPublicIps" {
  value = "${aws_instance.db.public_ip}"
}

output "DBPrivateIps" {
  value = "${aws_instance.db.private_ip}"
}

output "MonitorIPs" {
  value = "${aws_instance.monitor.public_ip}"
}

output "ElkIPs" {
  value = "${aws_instance.elk.public_ip}"
}

output "ElkInternalIPs" {
  value = "${aws_instance.elk.private_ip}"
}

