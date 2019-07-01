output "webInstanceIps" {
  value = "${aws_instance.web.public_ip}"
}


output "dbInstanceIps" {
  value = "${aws_instance.db.public_ip}"
}
