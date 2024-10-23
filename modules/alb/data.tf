data "aws_vpc" "main" {

  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}


data "aws_subnets" "public_subnets" {

  filter {
    name   = "tag:Name"
    values = ["public-subnet-1", "public-subnet-2"]
  }


  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}


data "aws_autoscaling_group" "frontend_asg" {
  name = "frontend_asg" #needs to be obtained
}


data "aws_autoscaling_group" "backend_asg" {
  name = "backend_asg" #needs to be obtained
}


data "aws_route53_zone" "teamfiveproject" {
  name = "teamfiveproject.click" # make sure name is correct
}


data "aws_s3_bucket" "existing_maintenance_page" {
  bucket = "##############" # need name for s3 bucket
}