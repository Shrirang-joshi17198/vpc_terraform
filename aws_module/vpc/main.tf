resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name = var.vpc_name
    }
}

resource "aws_internet_gateway" "my_internet_gateway" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "My-Internet-Gateway"
    }
}

resource "aws_eip" "nat_gateway_eip" {
    vpc = true
}

resource "aws_nat_gateway" "aws_nat_gateway" {
    allocation_id = aws_eip.nat_gateway_eip.id
    subnet_id     = aws_subnet.public[0].id

    depends_on = [aws_internet_gateway.my_internet_gateway]
}

resource "aws_subnet" "public" {
    count = var.public_subnet_count
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "Public-Subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count = var.private_subnet_count
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 2)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "Private-Subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "database" {
    count = var.database_subnet_count
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 4)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "Database-Subnet-${count.index + 1}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

resource "aws_route_table_association" "public" {
    count          = 2
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "private" {
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.aws_nat_gateway.id
}

resource "aws_route_table_association" "private" {
    count          = 2
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "database" {
    route_table_id         = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.aws_nat_gateway.id
}

resource "aws_route_table_association" "database" {
    count          = 2
    subnet_id      = aws_subnet.database[count.index].id
    route_table_id = aws_route_table.database.id
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

resource "aws_network_acl_association" "private" {
    count          = 2
    network_acl_id = aws_network_acl.private.id
    subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_network_acl_association" "database" {
    count          = 2
    network_acl_id = aws_network_acl.database.id
    subnet_id      = aws_subnet.database[count.index].id
}
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "public-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
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

  tags = {
    Name = "Public-SG"
  }
}


data "aws_availability_zones" "available" {}
