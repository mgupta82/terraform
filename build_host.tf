resource "aws_instance" "ec2form" {
  ami           = "ami-0970010f37c4f9c8d"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  disable_api_termination     = "false"
  iam_instance_profile = "ProvisioningInstanceProfile"
  tags = {
    Owner         = "test"
  }
  vpc_security_group_ids = ["sg-01ae51de2a1f41442"]

  user_data = <<EOF
  #!/bin/bash
  mkdir -p /home/ec2-user/.ssh
  cat > /home/ec2-user/.ssh/authorized_keys <<SSH
  ssh-rsa PUBLIC_KEY
  SSH
  chown -R ec2-user: /home/ec2-user
  chmod 600 /home/ec2-user/.ssh/authorized_keys
  source /etc/profile.d/proxy.sh
  yum install vim jq python2-pip nc git python36 -y
  su - ec2-user -c 'pip3 install --user ansible ansible-lint ansible_vault botocore boto3 ; pip2 install --user boto3'
  EOF
}

resource "aws_route53_record" "ec2form" {
  zone_id = "Z0231744CWY2JIMHJQX4"
  name    = "build-host.mukeshgupta.info"
  type    = "A"
  ttl     = "15"
  records = ["${aws_instance.ec2form.private_ip}"]
}
