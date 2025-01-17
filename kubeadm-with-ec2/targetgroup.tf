resource "aws_lb_target_group" "tg-master" {
  name        = "master-node-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prod-vpc.id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.tg-master.arn
  target_id        = aws_instance.master-node.id
  port             = 31599
}

resource "aws_lb_target_group" "tg-jenkins" {
  name        = "jenkins-node-tg"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prod-vpc.id 
  health_check {
    path = "/login"
  }
}

resource "aws_lb_target_group_attachment" "jenkins-tg-attach" {
  target_group_arn = aws_lb_target_group.tg-jenkins.arn
  target_id        = aws_instance.master-node.id
  port             = 8080

}