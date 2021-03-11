resource "aws_codedeploy_app" "app_deploy" {
  compute_platform = "Server"
  name             = "app-deploy"
}

resource "aws_codedeploy_deployment_config" "app_deploy" {
  deployment_config_name = "app-deploy-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_codedeploy_deployment_group" "app_deploy" {
  app_name               = aws_codedeploy_app.app_deploy.name
  deployment_group_name  = var.group_name
  service_role_arn       = aws_iam_role.build_pipeline_role.arn
  deployment_config_name = aws_codedeploy_deployment_config.app_deploy.id

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"   # key and value of your ec2 instance tag 
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
