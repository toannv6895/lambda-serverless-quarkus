data "aws_ses_email_identity" "ses_default_email_identity" {
  email = var.default_email
}

resource "aws_cognito_user_pool" "user-pool" {
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]
  email_verification_message = null
  email_verification_subject = null
  mfa_configuration          = "OPTIONAL"
  name                       = var.user_pool_name
  sms_authentication_message = null
  sms_verification_message   = null
  tags                       = {}
  tags_all                   = {}
  username_attributes        = null

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = file("${path.module}/template/email_message_template.txt")
      email_subject = "Verify your account"
      sms_message   = file("${path.module}/template/sms_message_template.txt")
    }
  }
  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }
  email_configuration {
    configuration_set      = null
    email_sending_account  = "DEVELOPER"
    from_email_address     = "Support <${var.default_email}>"
    reply_to_email_address = null
    source_arn             = data.aws_ses_email_identity.ses_default_email_identity.arn
  }
  lambda_config {
    create_auth_challenge          = null
    custom_message                 = module.email-configuration.lambda_function_arn
    define_auth_challenge          = null
    kms_key_id                     = null
    post_authentication            = null
    post_confirmation              = null
    pre_authentication             = null
    pre_sign_up                    = null
    pre_token_generation           = null
    user_migration                 = null
    verify_auth_challenge_response = null
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 4
  }
  
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "sites"
    required                 = false
    string_attribute_constraints {
      max_length = null
      min_length = null
    }
  }

  software_token_mfa_configuration {
    enabled = true
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }
  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }
  username_configuration {
    case_sensitive = false
  }
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message         = null
    email_message_by_link = null
    email_subject         = null
    email_subject_by_link = null
    sms_message           = null
  }
}

resource "aws_lambda_permission" "allow_permissions_to_invoke_lambda_from_cognito" {
  statement_id  = "CustomMessage_${aws_cognito_user_pool.user-pool.id}"
  action        = "lambda:InvokeFunction"
  function_name = module.email-configuration.lambda_function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user-pool.arn
  depends_on    = [aws_cognito_user_pool.user-pool, module.email-configuration.lambda_function_name]
}

# Create groups
resource "aws_cognito_user_group" "group" {
  for_each     = var.groups
  name         = each.value
  user_pool_id = aws_cognito_user_pool.user-pool.id
}

# Create user
resource "aws_cognito_user" "user" {
  for_each                 = { for user in toset(var.users) : user.username => user }
  user_pool_id             = aws_cognito_user_pool.user-pool.id
  username                 = each.value["username"]
  password                 = each.value["password"]
  attributes               = each.value["attributes"]
  desired_delivery_mediums = each.value["desired_delivery_mediums"]
  depends_on               = [aws_lambda_permission.allow_permissions_to_invoke_lambda_from_cognito]
}

# Add user to group
resource "aws_cognito_user_in_group" "add_user_into_group" {
  for_each     = { for user in toset(var.users) : user.username => user }
  user_pool_id = aws_cognito_user_pool.user-pool.id
  group_name   = tolist(each.value.authorities)[0]
  username     = each.value.username

  depends_on = [aws_cognito_user.user, aws_cognito_user_group.group]
}

# Create App client list
resource "aws_cognito_user_pool_client" "cognito-portal-client" {
  name                                          = "cognito-portal"
  access_token_validity                         = "1"
  allowed_oauth_flows                           = ["implicit"]
  allowed_oauth_flows_user_pool_client          = "true"
  allowed_oauth_scopes                          = ["email", "openid", "phone", "profile"]
  auth_session_validity                         = "15"
  callback_urls                                 = ["http://localhost:8080/authorization-code/callback"]
  enable_propagate_additional_user_context_data = "false"
  enable_token_revocation                       = "true"
  explicit_auth_flows                           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
  id_token_validity                             = "1"
  prevent_user_existence_errors                 = "ENABLED"
  read_attributes                               = ["address", "birthdate", "custom:sites", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  refresh_token_validity                        = "30"
  generate_secret                               = true
  token_validity_units {
    access_token  = "days"
    id_token      = "days"
    refresh_token = "days"
  }

  user_pool_id     = aws_cognito_user_pool.user-pool.id
  write_attributes = ["address", "birthdate", "custom:sites", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
}