### Criar o Amazon Cognito User Pool ###
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
}

### Criar o Amazon Cognito User Pool Client ###
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

### Criar o Amazon Cognito Identity Pool ###
resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = var.user_identity_pool
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.user_pool_client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }
}

### Criar uma Role para usuários autenticados ###
resource "aws_iam_role" "authenticated_role" {
  name = var.cognito_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.identity_pool.id
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "authenticated"
          }
        }
      }
    ]
  })
}

### Criar a Policy de Acesso ao S3 ###
resource "aws_iam_policy" "authenticated_policy" {
  name = "Cognito_authenticated_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.user_files.arn}/private/$${cognito-identity.amazonaws.com:sub}/*"
      }
    ]
  })
}

### Anexar a Policy à Role ###
resource "aws_iam_role_policy_attachment" "authenticated_policy_attachment" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = aws_iam_policy.authenticated_policy.arn
}

### Vincular o Identity Pool com a Role de Autenticados ###
resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    authenticated = aws_iam_role.authenticated_role.arn
  }
}