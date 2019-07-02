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

