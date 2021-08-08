local _M = {}

function _M.execute(plugin_conf)
    local jwt = require 'resty.jwt'
    local ngx = require 'ngx'

    -- get jwt from header, it's the kong-oidc plugin design
    local token = kong.request.get_header("x-access-token") or get_bearer_token() 
    kong.log.err("token is ", token)
    if token == nil then
       return kong.response.exit(403, "Forbidden")
    end
    -- decode jwt
    local jwt_obj = jwt:load_jwt(token)
    -- get what we need
    local groups_array = jwt_obj['payload']['groups']
    local required_groups_array = plugin_conf.required_groups
    kong.log.err("required groups size is ", table.getn(required_groups_array))

    if (table.getn(required_groups_array) == 0) then
        -- authorized
    else
        -- check
        local count = 0;
        for _, group in pairs(groups_array) do
            for i=1, table.getn(required_groups_array) do
                if group == required_groups_array[i] then
                    kong.log.err(group, " is complied")
                    count = count + 1
                    break
                end
            end
        end
        if (table.getn(required_groups_array) == count) then
            -- all complied, authorized
        else
            -- unauthorized
            return kong.response.exit(401, "Unauthorized")
        end
    end
end

function get_bearer_token()
  local header = kong.request.get_header('Authorization')
  kong.log.err(header)
  if header and header:find(" ") then
    local divider = header:find(' ')
    kong.log.err((header:sub(0, divider-1)))
    if string.lower(header:sub(0, divider-1)) == string.lower("Bearer") then
       local access_token = header:sub(divider + 1)
       if access_token then
         return access_token
       end
    end
  end

  kong.log.err("no Bearer access token value found")
  return nil
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

return _M

