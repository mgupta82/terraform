output "build_host_ip" {
  value = "${aws_instance.ec2form.private_ip}"
}

output "build_host_fqdn" {
  value = "${aws_route53_record.ec2form.name}"
}
