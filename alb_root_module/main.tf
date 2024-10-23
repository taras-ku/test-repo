provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::021891589585:role/team5-administrators"
    session_name = "TerraformSession"
  }
}


module "alb" {
  source               = "../modules/alb_module"
  alb_name             = "teamfiveproject-alb"
  frontend_host_header = ["reviews.teamfiveproject.click"]
  backend_host_header  = ["reviews-api.teamfiveproject.click"]
  alb_sg_name          = "teamfiveproject-alb-sg"
  frontend_tg_name     = "frontend-tg"
  backend_tg_name      = "backend-tg"

}