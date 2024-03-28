variable "stage" {
  type        = string
  description = "Stage to deploy in."
}

variable "user_pool_name" {
  type        = string
  description = "(Optional) Configuration user pool name"
  default     = "user-management-test"
}

variable "default_email" {
  type        = string
  description = "Name of the lambda function to configure SES"
  default     = "toannv6895@gmail.com"
}

variable "groups" {
  type        = set(string)
  description = "Group names to create in the user pool"
  default     = ["SUPER_ADMIN", "ADMIN", "USER"]
}

variable "users" {
  type = list(object({
    username                 = string,
    password                 = string,
    authorities              = set(string),
    attributes               = map(string),
    desired_delivery_mediums = set(string)
  }))

  description = "List of users to create in the user pool"
  default = [
    {
      username                 = "super_admin"
      password                 = "@SuperAdminTest12345679"
      authorities              = ["SUPER_ADMIN"]
      desired_delivery_mediums = ["EMAIL"]
      attributes = {
        "email"                     = "super_admin@gmail.com",
        "name"                      = "10000",
        "family_name"               = "Admin",
        "given_name"                = "Super",
        "phone_number"              = "+1234567890",
        "custom:sites"              = "[1, 2, 3]",
        "email_verified"            = "true"
      }
    },
    {
      username                 = "admin"
      password                 = "@AdminTest12345679"
      authorities              = ["ADMIN"]
      desired_delivery_mediums = ["EMAIL"]
      attributes = {
        "email"                     = "admin@gmail.com",
        "name"                      = "10000",
        "family_name"               = "Admin",
        "given_name"                = "Cloud",
        "phone_number"              = "+1234567890",
        "custom:sites"              = "[1, 2, 3]",
        "email_verified"            = "true"
      }
    },
    {
      username                 = "user"
      password                 = "@UserTest12345679"
      authorities              = ["USER"]
      desired_delivery_mediums = ["EMAIL"]
      attributes = {
        "email"                     = "user@gmail.com",
        "name"                      = "10000",
        "family_name"               = "Test",
        "given_name"                = "User",
        "phone_number"              = "+1234567890",
        "custom:sites"              = "[1, 2, 3]",
        "email_verified"            = "true",
        "picture"                   = "test.png"
      }
    }
  ]
}