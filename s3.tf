resource "aws_s3_bucket" "app_web" {
  bucket = "${var.account_name}-app_web"
  acl    = "private"     
  versioning = {
    enabled = true 
  }
  tags = {
    Name        = "app_web"
    Environment = "Dev"
  }  
}                                      

resource "aws_s3_bucket_policy" "app_web" {
  bucket = "${aws_s3_bucket.app_web.id}"
  policy =<<POLICY
{
  "Id": "Policy1513880777555",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1513880773845",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.app_web.arn}",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.account_id}:role/${var.app}-app_web",
        ]
      }
    }
  ]
}
POLICY
}
