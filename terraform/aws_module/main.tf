module "vpc" {
  source               = "./vpc"
  vpc_name             = "MyVPC"
  public_subnet_count  = 2
  private_subnet_count = 2
  database_subnet_count = 2
}

module "ec2_instance" {
  source            = "./ec2"
  ami_id           = "ami-0c614dee691cbbf37"  
  instance_type    = "t2.micro"
  subnet_id        =  module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.public_security_group_id
  key_name         = "my_key"
  instance_name    = "MyEC2Instance"
}
module "dynamodb" {
  source      = "./dynamodb" 
  table_name  = "terraform-lock-table"
  environment = "prod" 
}

module "s3" {
  source = "./s3"
  bucket_name = "my-s3-bucket-terraform-tfstate"
  versioning_enabled = true
  
}

module "rds" {
  source = "./rds"  

  db_instance_identifier  = "my-database-instance"
  engine                  = "mysql"
  engine_version          = "8.0.40"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "admin1234" 
  db_subnet_group_name    = "my-db-subnet-group"
  db_subnet_ids           = module.vpc.database_subnet_ids
  vpc_security_group_ids  = [module.vpc.public_security_group_id]
  backup_retention_period = 7
  multi_az = true
  deletion_protection = false
  publicly_accessible = false
  
}
module "s3_backend" {
  source      = "./s3-backend"
  bucket_name = "my-s3-bucket-terraform-tfstate"  # Provide the bucket name
}

module "dynamodb_backend" {
  source      = "./dynamodb-backend"
  table_name  = "terraform-lock-table"      # Provide the DynamoDB table name
  environment = "prod"                      # Provide the environment name
}

terraform {
  backend "s3" {
    bucket         = "my-s3-bucket-terraform-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
