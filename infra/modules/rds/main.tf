resource "aws_db_subnet_group" "this" {
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot = true
}
