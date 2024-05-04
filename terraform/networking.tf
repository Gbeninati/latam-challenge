###########################
# VPC principal de la red #
###########################

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr 
	enable_dns_hostnames = true
    tags = {
        Name = "vpc-prod"
		Environment = "production"
    }
}

###############
# VPC Subnets #
###############

# Subnet application priv

resource "aws_subnet" "app-priv" {
	count = length(var.app_priv_subnets)
	vpc_id = aws_vpc.main.id
	map_public_ip_on_launch = false
	cidr_block = element(values(var.app_priv_subnets), count.index)
	availability_zone = element(keys(var.app_priv_subnets), count.index)
	tags = {
		Name = join("-", ["app-priv", count.index])
		Environment = "production"
	}
}

# Subnet DB

resource "aws_subnet" "db-priv" {
	count = length(var.db_priv_subnets)
	vpc_id = aws_vpc.main.id
	map_public_ip_on_launch = false
	cidr_block = element(values(var.db_priv_subnets), count.index)
	availability_zone = element(keys(var.db_priv_subnets), count.index)
	tags = {
		Name = join("-", ["db-priv", count.index])
		Environment = "production"
	}
}

#######################
# Grupos de seguridad #
#######################

# Aplicaciones a DB

resource "aws_security_group" "db-ingress" {
	name = "db-ingress"
	description = "Security group for Application Layer"
	vpc_id = aws_vpc.main.id
	tags = {
		Environment = "production"
	}
}

# Databases SG

resource "aws_security_group" "db-servers" {
	name = "db-servers"
	description = "Security group for DB Layer"
	vpc_id = aws_vpc.main.id
	tags = {
		Environment = "production"
	}
}

resource "aws_security_group_rule" "db-3306" {
	type = "ingress"
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	source_security_group_id = aws_security_group.db-ingress.id
	security_group_id = aws_security_group.db-servers.id
	depends_on = [aws_security_group.db-servers]
}

resource "aws_security_group_rule" "db-egress" {
	type = "egress"
	from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.db-servers.id
	depends_on = [aws_security_group.db-servers]
}

# Application SG

resource "aws_security_group" "latam-challenge" {
	name = "latam-challenge"
	description = "Security group for Lambda Latam Challenge function"
	vpc_id = aws_vpc.main.id
	tags = {
		Environment = "production"
	}
}

resource "aws_security_group_rule" "latam-challenge-egress" {
	type = "egress"
	from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.latam-challenge.id
	depends_on = [aws_security_group.latam-challenge]
}
