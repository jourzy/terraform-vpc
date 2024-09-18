/* There are more properties that can be configured,
 e.g. VPC endpoints, network ACLs, DHCP options, etc. */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

// Creates a VPC with CIDR range
resource "aws_vpc" "this" {
 cidr_block = var.cidr_block_vpc
 /* This enables DNS resolution within the VPC.
 If set to true, the VPC will use Amazon's DNS server to resolve domain names to IP addresses. */
 enable_dns_hostnames = true
 /* This allows instances within the VPC to have public DNS hostnames. 
 It’s useful when you want EC2 instances to be publicly reachable via DNS. */
 enable_dns_support = true
 
 tags = {
   Name = "Project"
 }
}

// Creates public subnets
resource "aws_subnet" "public" {
  /* The count parameter is used to create multiple instances of this resource 
   based on the length of the var.private_subnet_cidrs variable */
 count      = length(var.public_subnet_cidrs)
 // Assigns the subnet to the existing VPC by referencing the id of an AWS VPC resource
 vpc_id     = aws_vpc.this.id
 /* var.public_subnet_cidrs is a list of CIDR blocks for private subnets, 
  defined in variables.tf
  This assigns a CIDR block to each subnet from the public_subnet_cidrs list, one for each subnet.
  element(var.public_subnet_cidrs, count.index) is a function that selects an element from 
  the public_subnet_cidrs list based on the current count.index.
 cidr_block = element(var.public_subnet_cidrs, count.index) 
  Using the avz variable to map the subnets across these availability zones
 availability_zone = element(var.azs, count.index) */
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
  // The Name tag here is dynamic. 
  // For each subnet, it creates a name like "Private Subnet 1", "Private Subnet 2", etc.
   Name = "Public-${count.index + 1}"
 }
}
 
// Same as previous resource but for private subnets instead of public
resource "aws_subnet" "private" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.this.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private-${count.index + 1}"
 }
}

// Creating an internet gateway resource
resource "aws_internet_gateway" "this" {
 vpc_id = aws_vpc.this.id
 
 tags = {
   Name = "Project"
 }
}

/* Creating a route table which uses the existing 
 internet gateway so that traffic from the internet to access the public subnets.
 Best practise is to leave the default route table alone and create a second route table for this purpose */
resource "aws_route_table" "second" {
 vpc_id = aws_vpc.this.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.this.id
 }
 
 tags = {
   Name = "Project 2nd"
 }
}

// Explicitly associate the public subnets with the second route table
resource "aws_route_table_association" "this" {
 count = length(var.public_subnet_cidrs)
 /* Dynamic Subnet IDs: The subnet ID for each association is selected dynamically
  based on the iteration (count.index) and the list of subnet IDs (aws_subnet.public_subnets[*].id). */
 subnet_id      = element(aws_subnet.public[*].id, count.index)
 route_table_id = aws_route_table.second.id
}