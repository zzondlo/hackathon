name "cf-router"
  description "CloudFoundry Router Role"
  run_list(
    "recipe[cf-essentials]",
    "recipe[cf-ruby]",
    "recipe[cf-nginx]",
    "recipe[cf-router]"
  )


