output "vpc_id" {
  value = data.aws_vpc.main.id
}


output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids
}


output "frontend_asg_name" {
  value = data.aws_autoscaling_group.frontend_asg.name
}


output "backend_asg_name" {
  value = data.aws_autoscaling_group.backend_asg.name
}


output "teamfiveproject_zone" {
  value = data.aws_route53_zone.teamfiveproject.zone_id

}


output "s3_bucket_maimtanance_page" {
  value = data.aws_s3_bucket.existing_maintenance_page.website_endpoint

}