data "aws_secretsmanager_secret_version" "redshift-credentials" {
  # Fill in the name you gave to your secret
  secret_id = "prod/redshift/credentials"
}

locals {
  redshift_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.redshift-credentials.secret_string
  )
}

resource "aws_redshift_subnet_group" "redshift-subnet" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.db-priv.0.id, aws_subnet.db-priv.1.id, aws_subnet.db-priv.2.id]

  tags = {
    environment = "production"
  }

  depends_on = [aws_subnet.db-priv]
}

data "aws_iam_role" "ServiceRoleRedshift" {
  name = "AWSServiceRoleForRedshift"
}

data "aws_kms_key" "kms_redshift" {
  key_id = "alias/redshift"
}


resource "aws_redshift_cluster" "redshift-cluster-1" {
  cluster_identifier        = "redshift-cluster"
  database_name             = "latam_redshift"
  master_username           = "admin"
  master_password           = local.redshift_credentials.password
  node_type                 = "dc2.large"
  cluster_type              = "multi-node"
  number_of_nodes           = 2
  port                      = 5439
  vpc_security_group_ids    = [aws_security_group.db-servers.id]
  cluster_subnet_group_name = data.aws_redshift_subnet_group.redshift-subnet.name
  iam_roles                 = [data.aws_iam_role.ServiceRoleRedshift.arn]
  encrypted                 = true
  kms_key_id                = data.aws_kms_key.kms_redshift.arn
  publicly_accessible       = false
  skip_final_snapshot       = true
  
  lifecycle {
    ignore_changes = [master_password]
  }
  
  timeouts {}  

  depends_on = [aws_redshift_subnet_group.redshift-subnet]


}
