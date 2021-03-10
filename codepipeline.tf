resource "aws_codepipeline" "pipeline_project" {
  name     = "${var.app}-pipeline"
  role_arn = "${aws_iam_role.build_pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.web-app.id}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${var.app}"]

      configuration {
        Owner                = "${var.github_org}"
        Repo                 = "${var.project}"
        PollForSourceChanges = "true"
        Branch               = "main". #master
        OAuthToken           = "${var.github_token}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      version          = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.project.name}"
      }
    }
  }

  stage {
    name = "DeployDev"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.app}"]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.deploy_dev.name}"
      }
    }
  }  
}
