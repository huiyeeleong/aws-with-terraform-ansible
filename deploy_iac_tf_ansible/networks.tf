#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

#Create 2nd VPC in us-east-1
resource "aws_vpc" "vpc_master_oregon" {
  provider            = aws.region-worker
  cidr_block          = "192.168.0.0/16"
  enable_dns_support  = true
  enable_dns_hostname = true
  tags = {
    "Name" = "worker-vpc-jenkins"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

#create 2nd igw in us-east-1
resource "aws_internet_gateway" "igw2" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_oregon.id
}

#get all available az in vpc for master region
data "aws_availabilty_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

#create subnet 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availabilty_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
}

#create 2nd subnet in us-east1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availabilty_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"
}

#create 3rd subnet in us-east1
resource "aws_subnet" "subnet_3" {
  provider = aws.region-worker
  #availability_zone = element(data.aws_availabilty_zones.azs.names, 1)
  vpc_id     = aws_vpc.vpc_master_oregon.id
  cidr_block = "192.168.1.0/24"
}