
# Create a new Source Endpoint
resource "aws_dms_endpoint" "EC2Postgres" {
  endpoint_id                 = "EC2Postgres-endpoint"
  endpoint_type               = "source"
  engine_name                 = "postgres"
  password                    = "Uc@@s123"
  port                        = 5432
  server_name                 = "ip-10-0-1-204.ec2.internal"
  ssl_mode                    = "none"
  database_name               = "MIGTEST1"

  tags = {
    Name = "EC2Postgres"
  }

  username = "MIGTESTUSER"
}

