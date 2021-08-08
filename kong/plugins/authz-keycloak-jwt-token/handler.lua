local AuthzKeycloakJwtToken = require("kong.plugins.base_plugin"):extend()
local access = require 'kong.plugins.authz-keycloak-jwt-token.access'

function AuthzKeycloakJwtToken:new()
  AuthzKeycloakJwtToken.super.new(self, "authz-keycloak-jwt-token")
end

function AuthzKeycloakJwtToken:access(plugin_conf)
  AuthzKeycloakJwtToken.super.access(self)
    access.execute(plugin_conf)
end

AuthzKeycloakJwtToken.PRIORITY = 900  -- lower than oidc
AuthzKeycloakJwtToken.VERSION = "1.0.2"

return AuthzKeycloakJwtToken

