resource "aws_codebuild_project" "project" {
  name          = "${var.project}"
  description   = "${var.project} CodeBuild Project"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

#  environment {
#    compute_type = "BUILD_GENERAL1_SMALL"
#    image        = "${var.docker_build_image}"
#    type         = "LINUX_CONTAINER"
#  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
  
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }  
}

