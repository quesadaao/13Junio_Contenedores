

#7. create the ec2 with mongoserver
resource "aws_instance" "mongoserver" {  
  ami           = data.aws_ami.bitnami_mongo.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone_a
  subnet_id = aws_subnet.subnet_a.id
  vpc_security_group_ids = [ 
        aws_security_group.webserver.id, 
        aws_security_group.ssh.id,
        aws_security_group.mongo.id
      ]
  key_name = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  
  tags = {
    CreatedBy = "${var.created_by}"
    Name = "${var.project_name}_mongo_server"
  }

   user_data = <<-EOF
                #!/bin/bash
                sudo sed -i s/security:/#security:/g /opt/bitnami/mongodb/conf/mongodb.conf
                sudo sed -i s/authorization:/#authorization:/g /opt/bitnami/mongodb/conf/mongodb.conf
                sudo systemctl restart bitnami.service

                until sudo mongo admin --eval "db.users.find();";do echo "Esperando a que mongod responda" && sleep 3;done

                sudo mongo admin <<CREACION_DE_USUARIO
                    db.createUser({
                      user: "admindb",
                      pwd: "admindb",
                      roles:[{
                        role: "root",
                        db: "admin"
                      }] })
                CREACION_DE_USUARIO

                sudo mongo admin <<CAMBIO_PASS
                db.changeUserPassword("root", "${var.password_mongo}");
                CAMBIO_PASS
  EOF
}

#8. create the ec2 with webserver
resource "aws_instance" "webserver1" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone_a
  subnet_id = aws_subnet.subnet_a.id
  vpc_security_group_ids = [ 
        aws_security_group.webserver.id, 
        aws_security_group.ssh.id
      ]
  key_name = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  tags = {
    CreatedBy = "${var.created_by}"
    Name = "${var.project_name}_web_server"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    timeout     = "15m"
  }

  provisioner "file" {
    content = templatefile("default_node.js.tpl", {
      mongo_ip         = aws_instance.mongoserver.private_ip,
      mongodb_password = var.password_mongo
    })
    destination = "/tmp/default_node.js"
  }

  provisioner "file" {
    source ="nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "remote-exec" {
    script = "installNode.sh"
  }  
}

#8. create the ec2 with webserver
resource "aws_instance" "webserver2" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone_b
  subnet_id = aws_subnet.subnet_b.id
  vpc_security_group_ids = [ 
        aws_security_group.webserver.id, 
        aws_security_group.ssh.id
      ]
  key_name = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  
  tags = {
    CreatedBy = "${var.created_by}"
    Name = "${var.project_name}_web_server"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    timeout     = "15m"
  }

  provisioner "file" {
    content = templatefile("default_node.js.tpl", {
      mongo_ip         = aws_instance.mongoserver.private_ip,
      mongodb_password = var.password_mongo
    })
    destination = "/tmp/default_node.js"
  }

  provisioner "file" {
    source ="nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "remote-exec" {
    script = "installNode.sh"
  }  
}

output "load_balancer_dns_name" {
  value = aws_lb.front.dns_name
}