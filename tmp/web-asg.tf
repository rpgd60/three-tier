# Web tier autoscaling group
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.1.0"

  # Autoscaling group
  name = "${var.project_name}-web-${var.project_env}"

  min_size                  = 1
  max_size                  = 10
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  #   vpc_zone_identifier       = ["subnet-1235678", "subnet-87654321"]
  vpc_zone_identifier = module.vpc-webapp.private_subnets
  user_data           = filebase64("${path.module}/user-data.sh")

  # Load balancer associated with this ASG (optional)
  target_group_arns = module.alb-webapp.target_group_arns

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template

  use_lt    = true
  create_lt = true

  lt_name                = "${var.project_name}-asg-${var.project_env}"
  description            = "Web Tier Launch Template - ${var.project_name}-${var.project_env}"
  update_default_version = true


  key_name          = var.ec2_key_name
  image_id          = data.aws_ami.ubuntu.id
  instance_type     = var.ec2_instance_type
  ebs_optimized     = false
  enable_monitoring = false

  #   block_device_mappings = [
  #     {
  #       # Root volume
  #       device_name = "/dev/xvda"
  #       no_device   = 0
  #       ebs = {
  #         delete_on_termination = true
  #         encrypted             = true
  #         volume_size           = 20
  #         volume_type           = "gp2"
  #       }
  #       }, {
  #       device_name = "/dev/sda1"
  #       no_device   = 1
  #       ebs = {
  #         delete_on_termination = true
  #         encrypted             = true
  #         volume_size           = 30
  #         volume_type           = "gp2"
  #       }
  #     }
  #   ]

  #   capacity_reservation_specification = {
  #     capacity_reservation_preference = "open"
  #   }

  #   cpu_options = {
  #     core_count       = 1
  #     threads_per_core = 1
  #   }

  #   credit_specification = {
  #     cpu_credits = "standard"
  #   }

  #   instance_market_options = {
  #     market_type = "spot"
  #     spot_options = {
  #       block_duration_minutes = 60
  #     }
  #   }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  security_groups             = [aws_security_group.sec_internal_mgmt.id, aws_security_group.sec_alb.id]
  associate_public_ip_address = false
  #   network_interfaces = [
  #     {
  #       delete_on_termination = true
  #       description           = "eth0"
  #       device_index          = 0
  #   security_groups       = ["sg-12345678"]
  # }
  # ,
  # {
  #   delete_on_termination = true
  #   description           = "eth1"
  #   device_index          = 1
  #   security_groups       = ["sg-12345678"]
  # }
  #   ]

  placement = {
    availability_zone = module.vpc-webapp.azs[0]
  }

  #   tag_specifications = [
  #     {
  #       resource_type = "instance"
  #       tags          = { WhatAmI = "Instance" }
  #     },
  #     {
  #       resource_type = "volume"
  #       tags          = { WhatAmI = "Volume" }
  #     },
  #     {
  #       resource_type = "spot-instances-request"
  #       tags          = { WhatAmI = "SpotInstanceRequest" }
  #     }
  #   ]

  # tags = [
  #   {
  #     key                 = "Environment"
  #     value               = "dev"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "Project"
  #     value               = "megasecret"
  #     propagate_at_launch = true
  #   },
  # ]
  tags_as_map = local.tags
  # tags_as_map = {
  #   extra_tag1 = "extra_value1"
  #   extra_tag2 = "extra_value2"
  # }
}