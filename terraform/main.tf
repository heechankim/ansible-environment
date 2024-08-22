variable "ssh_key_name" {
  type = string
  default = "aws_admin_heechankim"
}


variable "managed_nodes_info" {
  type = map(string)
  default = {
    "tnode1-centos": "ami-036d9f5599f0612e6",
    "tnode2-ubuntu": "ami-08b2c3a9f2695e351",
    "tnode3-rhel": "ami-005722f667c8d84ea"
  }
}

module "control_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ansible-server"

  ami = "ami-036d9f5599f0612e6" // CentOS Stream 8 x86_64 20240311
  instance_type          = "c6g.large"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [data.aws_security_groups.this.ids[0]]
  subnet_id              = data.aws_subnets.this.ids[0]

  tags = {
    Terraform   = "true"
    Environment = "control-node"
  }
}


module "managed_nodes" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = var.managed_nodes_info

  name = each.key
  ami = each.value

  create_spot_instance = true
  spot_price           = "0.60"
  spot_type            = "persistent"

  instance_type          = "c6g.large"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [data.aws_security_groups.this.ids[0]]
  subnet_id              = data.aws_subnets.this.ids[0]

  tags = {
    Terraform   = "true"
    Environment = "managed-node"
  }
}