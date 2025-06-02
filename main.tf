data "aws_caller_identity" "current" {}

module "aws_vpc" {
  source      = "./modules/aws_vpc"
  vpc_name    = var.vpc_name
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "aws_route_table" {
  source           = "./modules/aws_route_table"
  vpc_id           = module.aws_vpc.vpc_id
  gateway_id       = module.aws_vpc.internet_gateway_id
  route_table_name = var.route_table_name
}

module "aws_subnet" {
  source         = "./modules/aws_subnet"
  vpc_id         = module.aws_vpc.vpc_id
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  environment    = var.environment
  subnet_count   = var.subnet_count
  route_table_id = module.aws_route_table.route_table_id
}

module "aws_security_group" {
  source  = "./modules/aws_security_group"
  sg_name = var.sg_name
  vpc_id  = module.aws_vpc.vpc_id
}

module "aws_ec2" {
  source            = "./modules/aws_ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.aws_subnet.subnet_ids[0]
  security_group_id = module.aws_security_group.security_group_id
  ec2_name          = var.ec2_name
}

module "aws_eip" {
  source       = "./modules/aws_eip"
  project_name = var.project_name
  environment  = var.environment
}

module "aws_nat_gateway" {
  source           = "./modules/aws_nat_gateway"
  eip_id           = module.aws_eip.eip_id
  public_subnet_id = module.aws_subnet.subnet_ids[0]
  project_name     = var.project_name
  environment      = var.environment
}

module "alb" {
  source              = "./modules/aws_lb"
  name                = "myapp"
  load_balancer_type  = var.load_balancer_type
  listener_protocol   = var.listener_protocol
  listener_port       = var.listener_port
  target_protocol     = var.target_protocol
  target_port         = var.target_port
  environment         = var.environment
  vpc_id              = module.aws_vpc.vpc_id
  subnet_ids          = module.aws_subnet.subnet_ids
  security_groups     = [module.aws_security_group.security_group_id]
}

module "aws_s3" {
  source      = "./modules/aws_s3"
  bucket_name = var.bucket_name
  environment = var.environment
}

module "aws_cloudwatch_logs" {
  source         = "./modules/aws_cloudwatch_logs"
  log_group_name = var.log_group_name
  retention_days = var.retention_days
  environment    = var.environment
}

module "aws_iam_role" {
  source         = "./modules/aws_iam_role"
  role_name      = var.role_name
  assume_service = var.assume_service
  environment    = var.environment
}

module "aws_iam_policy_attachment" {
  source     = "./modules/aws_iam_policy_attachment"
  role_name  = module.aws_iam_role.iam_role_name
  policy_arn = var.policy_arn
}

module "aws_cloudtrail" {
  source         = "./modules/aws_cloudtrail"
  trail_name     = var.trail_name
  s3_bucket_name = module.aws_s3.bucket_name
  account_id     = data.aws_caller_identity.current.account_id
}

module "autoscaling" {
  source           = "./modules/aws_autoscaling_group"
  name_prefix      = "myapp"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  subnet_ids       = module.aws_subnet.subnet_ids
}

module "elasticache" {
  source             = "./modules/aws_elasticache"
  name_prefix        = "myapp"
  node_type          = "cache.t3.micro"
  num_nodes          = 1
  subnet_ids         = module.aws_subnet.subnet_ids
  security_group_ids = [module.aws_security_group.security_group_id]
}

module "cpu_alarm" {
  source      = "./modules/aws_cloudwatch_metric_alarm"
  alarm_name  = "high-cpu-alarm"
  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  threshold   = 70
  dimensions = {
    InstanceId = module.aws_ec2.instance_id
  }
}

data "aws_availability_zones" "available" {}

module "ebs_volume" {
  source            = "./modules/aws_ebs_volume"
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 8
  volume_type       = "gp2"
  name              = "ebs-volume-free"
}

module "kms" {
  source      = "./modules/aws_kms_key"
  description = "Subbu Test KMS Key"
}

module "eks_cluster" {
  source           = "./modules/aws_eks"
  cluster_name     = "subbu-eks"
  cluster_role_arn = module.aws_iam_role.role_arn
  subnet_ids       = module.aws_subnet.subnet_ids
}
