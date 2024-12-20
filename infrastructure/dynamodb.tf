resource "aws_dynamodb_table" "user_files" {
  name           = var.user_files_tb_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "file_name"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "file_name"
    type = "S"
  }
}