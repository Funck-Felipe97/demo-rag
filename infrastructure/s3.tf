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

# Permissão para que o S3 invoque a função Lambda existente
resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_indexer_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.user_files.arn
}

# Configurando o evento de notificação do bucket S3
resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = aws_s3_bucket.user_files.id

  lambda_function {
    lambda_function_arn = var.lambda_indexer_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_invoke_lambda]
}