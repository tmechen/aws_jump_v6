resource "aws_iam_role" "s3_access_for_ec2_role" {
  name                = "s3_access_for_ec2_role"
  assume_role_policy  = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": [
            "ec2.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    EOF
}
resource "aws_iam_role_policy_attachment" "s3_access_for_ec2_role_attachment" {
  role       = aws_iam_role.s3_access_for_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_instance_profile" "s3_access_for_ec2_instance_profile" {
  name = "s3_access_for_ec2_instance_profile"
  role = aws_iam_role.s3_access_for_ec2_role.name
}
