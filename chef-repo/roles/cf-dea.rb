name "cf-dea"
  description "CloudFoundry DEA role"
  run_list(
    "recipe[essentials]",
    "recipe[ruby]",
    "recipe[ruby::ruby18]",
    "recipe[dea]",
    "recipe[mongodb]",
    "recipe[rabbitmq]",
    "recipe[mysql]", 
    "recipe[mysql::server]",
    "recipe[nodejs]",
    "recipe[erlang]" ,
    "recipe[java]" ,
    "recipe[redis]"
  )
  


