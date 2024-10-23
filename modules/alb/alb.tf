resource "aws_lb" "main_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public_subnets.ids
}
#########

resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

##########

resource "aws_lb_target_group" "frontend_tg" {
  name     = var.frontend_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = var.backend_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    protocol = "HTTP"
    path     = "/health"
  }
}

##########


resource "aws_autoscaling_attachment" "frontend_asg_attachment" {
  autoscaling_group_name = data.aws_autoscaling_group.frontend_asg.name
  lb_target_group_arn    = aws_lb_target_group.frontend_tg.arn
}


resource "aws_autoscaling_attachment" "backend_asg_attachment" {
  autoscaling_group_name = data.aws_autoscaling_group.backend_asg.name
  lb_target_group_arn    = aws_lb_target_group.backend_tg.arn
}

###########

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid host header."
      status_code  = "400"
    }
  }
}


resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100 # may change 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  condition {
    host_header {
      values = var.frontend_host_header #["reviews.teamfiveproject.click"]
    }
  }
}



resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 200 # may change

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = var.backend_host_header #["reviews-api.teamfiveproject.click"]
    }
  }
}



