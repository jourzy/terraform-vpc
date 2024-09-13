
variable "cidr_block_vpc" {
 description = "CIDR block range for VPC"
 type        = string
 default       = "10.0.0.0/16"
}

// Identifying the CIDR ranges to be used for each subnet
variable "public_subnet_cidrs" {
 description = "Public Subnet CIDR values"
 type        = list(string)
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 description = "Private Subnet CIDR values"
 type        = list(string)
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

// A variable to store the list of availability zones
variable "azs" {
 description = "Availability Zones"
 type        = list(string)
 default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}