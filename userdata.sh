# #!/bin/bash
# sudo apt-get -y update

# #Installing java
# sudo apt-get -y install openjdk-11-jdk
# # Install Jenkins
# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get -y update
# sudo apt-get -y install jenkins
# sudo systemctl enable --now jenkins
# #install docker
# sudo apt-get install docker.io -y
# #solve error docker
# sudo chmod 666 /var/run/docker.sock
# sudo su $USER  -c groups
# sudo chgrp docker /lib/systemd/system/docker.socket
# sudo chmod g+w /lib/systemd/system/docker.socket
# sudo chgrp $USER /lib/systemd/system/docker.socket
# sudo chmod g+w /lib/systemd/system/docker.socket

# #add jenkins to user docker
# sudo groupadd docker
# sudo usermod -aG docker jenkins
# sudo usermod -aG root jenkins
# sudo usermod -aG docker ubuntu
# cat /etc/group | grep docker
# sudo reboot