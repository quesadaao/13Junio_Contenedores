
data "aws_ami" "bitnami_mongo" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-mongodb-4.4.15-0-linux-debian-10-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # 
}

data "aws_ami" "ubuntu" { 
  most_recent = true 

  filter { 
    name = "name" 
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]     
  }

  filter { 
      name = "virtualization-type" 
      values = ["hvm"]
  } 
  
  owners = ["099720109477"] # Canonical   
}