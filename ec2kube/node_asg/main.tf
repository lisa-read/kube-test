terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "lisaread-terra-bucket"
    key    = "node_asg/terraform.tfstate"
    region = "us-west-2"
  }

}

provider "aws" {
  region = "us-west-2"
}


data "aws_subnet" "kube_subnet_id" {
  
  filter {
    name   = "tag:Name"
    values = ["kube_subnet"]
  }

#   most_recent = true
}

data "aws_subnet" "kube_subnet_id_2" {
  
  filter {
    name   = "tag:Name"
    values = ["kube_subnet_2"]
  }

#   most_recent = true
}



data "aws_security_group" "kube_sg_id" {
  
  filter {
    name   = "tag:Name"
    values = ["kube_sg"]
  }

#   most_recent = true
}


resource "aws_launch_configuration" "kube_node_launch_conf" {
  name_prefix   = "kube_node_launch_conf-"
  image_id      = "ami-0e472ba40eb589f49" #us-west-2
  instance_type = "t2.micro"
  key_name = var.ssh_key_name
  security_groups = [data.aws_security_group.kube_sg_id.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "kube_node_asg" {
  name                 = "kube_node_asg"
  launch_configuration = resource.aws_launch_configuration.kube_node_launch_conf.name
  min_size             = 2
  max_size             = 5
  desired_capacity          = 4
  vpc_zone_identifier       = [data.aws_subnet.kube_subnet_id.id, data.aws_subnet.kube_subnet_id_2.id]

  tag {
    key                 = "instancemode"
    value               = "node"
    propagate_at_launch = true
  }
 
}