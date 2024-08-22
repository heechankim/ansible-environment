data "aws_vpcs" "this" {
  tags = {
    Name = "default"
  }
}

data "aws_security_groups" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

output "aws_subnets" {
  value = data.aws_subnets.this
}