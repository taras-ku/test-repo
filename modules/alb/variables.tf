variable "alb_name" {
  type        = string
  description = "Name for alb"

}

variable "frontend_host_header" {
  type        = list(string) #do not forget about type  ["reviews.teamfiveproject.click"]
  description = "host header name for frontend"

}

variable "backend_host_header" {
  type        = list(string) #do not forget about type ["reviews-api.teamfiveproject.click"]
  description = "host header name for backend"

}

variable "alb_sg_name" {
  type        = string
  description = "Name for ALB security group"

}

variable "frontend_tg_name" {
  type        = string
  description = "Name for frontend target group"

}

variable "backend_tg_name" {
  type        = string
  description = "Name for backend target group"

}