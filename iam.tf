resource "aws_iam_role" "build_pipeline_role" {
  name = "build-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"
  role = aws_iam_role.build_pipeline_role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Effect": "Allow",
       "Action": "codebuild:*",
       "Resource": [
          "${aws_codebuild_project.project.id}",
          "${aws_codepipeline_project.project.id}"
  
       ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "autoscaling:*",
        "codebuild:*",
        "codepipeline:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "iam:*",
        "logs:*",
        "rds:DescribeDBInstances",
        "route53:*",
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:PutParameter"
      ],
      "Resource": "arn:aws:ssm:us-east-2:${var.account_id}:parameter/*"
    }
  ]
}
POLICY
}
