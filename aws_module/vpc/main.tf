#vpc
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

}
resource "aws_internet_gateway" "my_internet_gateway" {
    vpc_id = aws_vpc.my_vpc.id

}
resource "aws_eip" "nat_gateway_eip" {
    vpc = true
  
}
resource "aws_nat_gateway" "aws_nat_gateway" {
    allocation_id = aws_eip.nat_gateway_eip.id
    subnet_id = aws_subnet.public[0].id
}
resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
  
}
resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 2)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
  
}
resource "aws_subnet" "database" {
    count = 2
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 4)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
  
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.my_vpc.id

  
}
resource "aws_route" "public" {
    count = 2
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_nat_gateway.id
}
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.my_vpc.id
  
}
resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.aws_nat_gateway.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
  
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "PublicNACL"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "PrivateNACL"
  }
}
resource "aws_network_acl" "database" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "DatabaseNACL"
    }
  
}
resource "aws_network_acl_rule" "public_ingress_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_ingress_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
data "aws_availability_zones" "available" {}