locals {
  tags = [
    {
      "key"                 = "Name"
      "value"               = "app-server"
      "propagate_at_launch" = true
    }
  ]

  #  webhook_secret = "my-secret-web"
}
