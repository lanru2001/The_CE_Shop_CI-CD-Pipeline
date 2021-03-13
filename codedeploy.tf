resource "aws_codedeploy_app" "application_deploy" {
  compute_platform = "Server"
  name             = "application-deploy"
}

resource "aws_codedeploy_deployment_config" "application_deploy" {
  deployment_config_name = "application-deploy-config"
  compute_platform = "Server"
  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_codedeploy_deployment_group" "app_deploy" {
  app_name               = aws_codedeploy_app.application_deploy.name
  deployment_group_name  = var.group_name
  service_role_arn       = aws_iam_role.build_role.arn
  deployment_config_name = aws_codedeploy_deployment_config.application_deploy.id

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name" # key and value of your ec2 instance tag 
      type  = "KEY_AND_VALUE"
      value = "web_server"
    }

    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "web_server"
    }
  }

  #trigger_configuration {
  #  trigger_events     = ["DeploymentFailure"]
  #  trigger_name       = "app_deploy-trigger"
  #  trigger_target_arn = "app_deploy-topic-arn"
  #}

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}
