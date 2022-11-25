resource "aws_launch_configuration" "web" {
  name_prefix   = "web"
  image_id      = "ami-0e6329e222e662a52"                                     #data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.alb_sg.id}" ]
  associate_public_ip_address = true
  #key_name = "nso_key"
  user_data = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "ntp" {
  name_prefix   = "ntp"
  image_id      = "ami-0e6329e222e662a52"                                     #data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.alb_sg.id}" ]
  associate_public_ip_address = true
  #key_name = "nso_key"
  user_data = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "DB" {
  name_prefix   = "DB"
  image_id      = "ami-0e6329e222e662a52"                                     #data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.alb_sg.id}" ]
  associate_public_ip_address = true
  #key_name = "nso_key"
  user_data = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "workstation" {
  name_prefix   = "workstation"
  image_id      = "ami-0e6329e222e662a52"                                     #data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.alb_sg.id}" ]
  associate_public_ip_address = true
  #key_name = "nso_key"
  user_data = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}