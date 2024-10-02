# Terraform VPC Module

This repository provides a Terraform module to create and manage an AWS Virtual Private Cloud (VPC) and its related resources such as subnets, route tables, and internet gateways. The module is designed to be reusable and configurable to suit different VPC setups.

## Features

- Create a VPC with customizable CIDR blocks
- Provision public and private subnets across multiple availability zones
- Attach an Internet Gateway (IGW) for public subnets
- Support for optional tags to manage resources efficiently
- Create route tables and associate them with subnets

## Requirements

- Terraform `>= 1.0.0`
- AWS Provider `>= 3.0`

## Usage

```hcl
module "vpc" {
  source = "github.com/jourzy/terraform-vpc"

  vpc_cidr_block = "10.0.0.0/16"
  
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

}
```


## Inputs

| Name                   | Description                                         | Type           | Default        | Required |
| ---------------------- | --------------------------------------------------- | -------------- | -------------- | -------- |
| `cidr_block_vpc`        | The CIDR block for the VPC                          | `string`       | n/a            | yes      |
| `public_subnet_cidrs`        | List of CIDR blocks for public subnets              | `list(string)` | `[]`           | yes      |
| `private_subnet_cidrs`       | List of CIDR blocks for private subnets             | `list(string)` | `[]`           | yes      |
| `azs`    | List of availability zones for subnets              | `list(string)` | `[]`           | yes      |
|

## Outputs

| Name               | Description                              |
| ------------------ | ---------------------------------------- |
| `public_subnet_ids`| List of IDs of the public subnets         |
| `private_subnet_ids`| List of IDs of the private subnets        |
|


## Resources created

This module will create the following AWS resources:

- VPC
- Subnets (public and private)
- Internet Gateway (IGW)
- Route Tables
- Routes for internet access (for public subnets)

## Examples

### Basic VPC with public subnets

```
module "vpc" {
  source = "github.com/jourzy/terraform-vpc"

  vpc_cidr_block = "10.0.0.0/16"
  
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  availability_zones = ["us-east-1a", "us-east-1b"]

  tags = {
    Name        = "my-public-vpc"
    Environment = "test"
  }
}
```

### VPC with public and private subnets

```
module "vpc" {
  source = "github.com/jourzy/terraform-vpc"

  vpc_cidr_block = "10.0.0.0/16"
  
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  availability_zones = ["us-east-1a", "us-east-1b"]

  tags = {
    Name        = "my-private-vpc"
    Environment = "prod"
  }
}
```

## Prerequisites

- Ensure that AWS credentials are set up for Terraform to manage resources. This can be done by configuring the AWS CLI or setting up environment variables:

```
export AWS_ACCESS_KEY_ID=your-access-key-id
export AWS_SECRET_ACCESS_KEY=your-secret-access-key
```

## License

This module is licensed under the MIT License. See the [LICENSE](https://opensource.org/license/MIT) file for more information.

## Contributing

Feel free to open an issue or submit a pull request if you have any ideas or improvements. All contributions are welcome!