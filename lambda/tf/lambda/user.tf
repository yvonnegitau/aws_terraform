resource "aws_iam_user" "gh_actions" {
  name = "github_action_deploy_user"
  path = "/"
  
}

resource "aws_iam_access_key" "gh_actions" {
  user = aws_iam_user.gh_actions.name
}

resource "aws_secretsmanager_secret" "gh_actions" {
  description             = "GitHub actions Lambda Code user credentials"
  name                    = "github_action_deploy_user_credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gh_actions" {
  secret_id     = aws_secretsmanager_secret.gh_actions.id
  secret_string = jsonencode({ "aws_access_key_id" = aws_iam_access_key.gh_actions.id, "aws_secret_access_key" = aws_iam_access_key.gh_actions.secret })
}