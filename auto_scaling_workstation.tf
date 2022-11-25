resource "aws_autoscaling_group" "workstation" {
  name = "${aws_launch_configuration.workstation.name}-asg"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.elb.id}"
  ]
launch_configuration = "${aws_launch_configuration.workstation.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
    "${aws_subnet.subnet1.id}",
    "${aws_subnet.subnet2.id}"
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
    key                 = "Name"
    value               = "workstation"
    propagate_at_launch = true
  }
}




resource "aws_autoscaling_policy" "workstation_policy_up" {
  name = "workstation_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.workstation.name}"
}
resource "aws_cloudwatch_metric_alarm" "workstation_cpu_alarm_up" {
  alarm_name = "workstation_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.workstation.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.workstation_policy_up.arn}" ]
}
resource "aws_autoscaling_policy" "workstation_policy_down" {
  name = "workstation_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.workstation.name}"
}
resource "aws_cloudwatch_metric_alarm" "workstation_cpu_alarm_down" {
  alarm_name = "workstation_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.workstation.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.workstation_policy_down.arn}" ]
}