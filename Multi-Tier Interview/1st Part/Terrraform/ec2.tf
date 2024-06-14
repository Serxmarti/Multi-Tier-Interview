resource "aws_instance" "web_server" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.security_groups.app_sg]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    yum install -y amazon-cloudwatch-agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
  EOF

  subnet_id = element(var.public_subnet_ids, 0)
}

resource "aws_launch_configuration" "app_server_lc" {
  name          = "app-server-lc"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [module.security_groups.app_sg]
  user_data     = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    yum install -y amazon-cloudwatch-agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
  EOF
}

resource "aws_autoscaling_group" "app_server_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  launch_configuration = aws_launch_configuration.app_server_lc.id
  vpc_zone_identifier  = var.public_subnet_ids
}
