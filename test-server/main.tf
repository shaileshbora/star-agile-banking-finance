resource "aws_instance" "test-server" {
  ami           = "ami-00c39f71452c08778" 
  instance_type = "t2.micro" 
  key_name = "project"
  vpc_security_group_ids= ["sg-0667b958966051a4a"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./project.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Finance_Me_Project/test-server/finance-playbook.yml "
  } 
}
