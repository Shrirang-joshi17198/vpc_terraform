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

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "rds_arn" {
  value = module.rds.db_instance_arn
}
