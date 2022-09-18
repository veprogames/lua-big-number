Notation = {}
Notation.__index = Notation
Notation.__tostring = function ()
    return "Notation"
end

function Notation:new()
    return setmetatable({}, Notation)
end

function Notation:get_prefix(n)
    return ""
end

function Notation:get_number(n)
    return ""
end

function Notation:get_suffix(n)
    return ""
end

function Notation:format(n)
    return self:get_prefix(n) .. self:get_number(n) .. self.get_suffix(n)
end

return Notation