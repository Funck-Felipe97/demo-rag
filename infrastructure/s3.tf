### Criar o S3 Bucket ###
resource "aws_s3_bucket" "user_files" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.user_files.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

### Policy do S3 ###
data "aws_iam_policy_document" "s3_policy" {
  ### ListBucket Action (With Condition for prefix) ###
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.user_files.arn}"
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "private/$${aws:userid}/*"
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"
  }

  ### Object-level Actions (Without Condition) ###
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.user_files.arn}/private/$${aws:userid}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.user_files.id
  policy = data.aws_iam_policy_document.s3_policy.json
}