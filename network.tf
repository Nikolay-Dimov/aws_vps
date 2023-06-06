#############################################
#################### VPC ####################
#############################################


resource "aws_vpc" "vpc_demo_1" {
  cidr_block = lookup(var.cidr_block, "vpc_route")
}

#############################################
############## INTERNET GATEWAY #############
#############################################


resource "aws_internet_gateway" "int_gateway_demo" {
  vpc_id = aws_vpc.vpc_demo_1.id

}


#############################################
############## PUBLICK SUBNETS ##############
#############################################

## 1 ##
resource "aws_subnet" "publick_subnet_1" {
  vpc_id            = aws_vpc.vpc_demo_1.id
  cidr_block        = lookup(var.cidr_block, "publick_1")
  availability_zone = lookup(var.availability_zone, "availability_zone_1")

}

resource "aws_route_table" "route_tables_publick_1" {
  vpc_id = aws_vpc.vpc_demo_1.id

  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_internet_gateway.int_gateway_demo.id
  }
}

resource "aws_route_table_association" "route_association_publick_1" {
  subnet_id      = aws_subnet.publick_subnet_1.id
  route_table_id = aws_route_table.route_tables_publick_1.id
}


## 2 ##
resource "aws_subnet" "publick_subnet_2" {
  vpc_id            = aws_vpc.vpc_demo_1.id
  cidr_block        = lookup(var.cidr_block, "publick_2")
  availability_zone = lookup(var.availability_zone, "availability_zone_2")

}

resource "aws_route_table" "route_tables_publick_2" {
  vpc_id = aws_vpc.vpc_demo_1.id

  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_internet_gateway.int_gateway_demo.id
  }
}

resource "aws_route_table_association" "route_association_publick_2" {
  subnet_id      = aws_subnet.publick_subnet_2.id
  route_table_id = aws_route_table.route_tables_publick_2.id
}




#############################################
############## PRIVATE SUBNETS ##############
#############################################

## 1 ##
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.vpc_demo_1.id
  cidr_block        = lookup(var.cidr_block, "private_1")
  availability_zone = lookup(var.availability_zone, "availability_zone_1")

}

resource "aws_route_table" "route_table_privet_1" {
  vpc_id = aws_vpc.vpc_demo_1.id
  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_nat_gateway.nat_1.id

  }

}

resource "aws_route_table_association" "route_association_privet_1" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.route_table_privet_1.id

}

resource "aws_eip" "eip_1" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.private_subnet_3.id
}



## 2 ##
resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.vpc_demo_1.id
  cidr_block        = lookup(var.cidr_block, "private_2")
  availability_zone = lookup(var.availability_zone, "availability_zone_2")

}

resource "aws_route_table" "route_table_privet_2" {
  vpc_id = aws_vpc.vpc_demo_1.id
  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_nat_gateway.nat_2.id

  }

}

resource "aws_route_table_association" "route_association_privet_2" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.route_table_privet_2.id

}

resource "aws_eip" "eip_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.private_subnet_4.id
}

