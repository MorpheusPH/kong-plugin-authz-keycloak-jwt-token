package = "kong-plugin-authz-keycloak-jwt-token"
version = "1.0-2"
local pluginName = package:match("^kong%-plugin%-(.+)$")
source = {
  url = "https://github.com/MorpheusPH/kong-plugin-authz-keycloak-jwt-token",
  branch = "main",
}
description = {
  summary = "A Kong plugin based on jwt authroized by keycloak",
  license = "Apache 2.0"
}
dependencies = {
  "lua-resty-jwt ~> 0.2.3-0"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins." .. pluginName .. ".handler"] = "kong/plugins/" .. pluginName .. "/handler.lua",
    ["kong.plugins." .. pluginName .. ".schema"]  = "kong/plugins/" .. pluginName .. "/schema.lua",
    ["kong.plugins." .. pluginName .. ".access"]  = "kong/plugins/" .. pluginName .. "/access.lua",
  }
}

