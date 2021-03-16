resource "aws_iam_role" "build_role" {
  name               = "build-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com"
          
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
  policy      = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
			"Effect": "Allow",
			"Resource": [
				"*"
			],
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
                               
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:GetObjectVersion",
				"s3:GetBucketAcl",
				"s3:GetBucketLocation"
			],
			"Resource": [
				"*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"codebuild:CreateReportGroup",
				"codebuild:CreateReport",
				"codebuild:UpdateReport",
				"codebuild:BatchPutTestCases",
				"codebuild:*",
				"codebuild:BatchPutCodeCoverages"
			],
			"Resource": [
				"arn:aws:codebuild:us-east-2:216147165517:*"
			]
		}
	]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "build_pipeline" {
  role       = aws_iam_role.build_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}


resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
     
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.app_web.arn}",   
        "${aws_s3_bucket.app_web.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#data "aws_kms_alias" "s3kmskey" {
# name = "alias/myKmsKeyMainKey"
#}


resource "aws_iam_role" "deploy_role" {
  name               = "deploy-role"
  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
            "Service": [
               "codedeploy.amazonaws.com"
            ]
         },
         "Action": "sts:AssumeRole"
         }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy_role.name
}
