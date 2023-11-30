provider "aws" {
  region = var.region
}
resource "aws_security_group" "JenkinsSG" {
  name = "Jenkins SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "JenkinsEC2" {
  instance_type          = var.instance_type
  ami                    = "ami-0efcece6bed30fd98"
  vpc_security_group_ids = [aws_security_group.JenkinsSG.id]
  key_name               = var.ssh_key_name

  tags = {
    Name = "terraform-jenkins-master"
  }
  user_data = <<-EOF
    #!/bin/bash
    # Installing Java
    sudo apt-get update -y
    sudo apt install openjdk-11-jre -y
    java --version

    # Installing Jenkins
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install jenkins -y
    sudo apt-get install docker.io -y
    #solve error docker
    sudo chmod 666 /var/run/docker.sock
    sudo su $USER  -c groups
    sudo chgrp docker /lib/systemd/system/docker.socket
    sudo chmod g+w /lib/systemd/system/docker.socket
    sudo chgrp $USER /lib/systemd/system/docker.socket
    sudo chmod g+w /lib/systemd/system/docker.socket
    #add jenkins to user docker
    sudo groupadd docker
    sudo usermod -aG docker jenkins
    sudo usermod -aG root jenkins
    sudo usermod -aG docker ubuntu
    cat /etc/group | grep docker
    sudo reboot
  EOF
}

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"]

# }

output "jenkins_endpoint" {
  value = formatlist("http://%s:%s/", aws_instance.JenkinsEC2.*.public_ip, "8080")
}