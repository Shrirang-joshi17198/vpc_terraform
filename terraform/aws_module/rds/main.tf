resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "this" {
  identifier            = var.db_instance_identifier
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  username              = var.username
  password              = var.password
  db_subnet_group_name  = aws_db_subnet_group.this.id
  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  deletion_protection     = var.deletion_protection
  publicly_accessible     = var.publicly_accessible

  skip_final_snapshot = false
  

  tags = {
    Name = var.db_instance_identifier
  }
}


