

# Create Postgres DB EC2

resource "aws_instance" "DBInst" {
  ami    = "ami-013f17f36f8b1fefb"
  instance_type = "t2.micro"
  key_name    = "my-web-keypair"
  subnet_id = aws_subnet.Web_Subnet_1a.id
  associate_public_ip_address  = true
  vpc_security_group_ids = [aws_security_group.allow_5432.id,aws_security_group.allow_ssh.id]
  user_data = file("install-postgres.sh")
    tags = {
    Name = "Db-Server"
  }
}