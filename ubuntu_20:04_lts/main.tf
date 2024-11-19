data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # ID de propriétaire officiel pour Ubuntu
}

locals {
  ami_id               = data.aws_ami.ubuntu.id
  key_name             = var.key_name
  filename             = "./keypair/${var.key_name}.pem"
  username             = var.username
  instance_type        = var.instance_type
  security_groups_name = var.security_groups_name
  environment_tag      = var.environment_tag
  instance_name        = var.instance_name
}
module "keypair" {
  source   = "./modules/keypair"
  key_name = local.key_name
  filename = local.filename
}

module "ec2" {
  source               = "./modules/ec2"
  ami                  = local.ami_id
  instance_type        = local.instance_type
  security_groups_name = module.sg.sg_pwd_name
  key_name             = local.key_name
  username             = local.username
  private_key_path     = local.filename
  environment_tag      = local.environment_tag
  instance_name        = local.instance_name
}

module "sg" {
  source               = "./modules/sg"
  security_groups_name = local.security_groups_name
  environment_tag      = local.environment_tag
}