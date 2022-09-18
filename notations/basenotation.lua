BaseNotation = {}
BaseNotation.__index = BaseNotation
BaseNotation.__tostring = function ()
    return "Notation"
end

function BaseNotation:new()
    return setmetatable({}, BaseNotation)
end

function BaseNotation:get_prefix(n)
    return ""
end

function BaseNotation:get_number(n)
    return ""
end

function BaseNotation:get_suffix(n)
    return ""
end

function BaseNotation:format(n)
    return self:get_prefix(n) .. self:get_number(n) .. self.get_suffix(n)
end

return BaseNotation