resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>Welcome to My Nginx Server</h1>" | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = var.instance_name
  }
}
