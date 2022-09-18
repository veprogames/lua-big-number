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

function Notation:get_number(n, places)
    return ""
end

function Notation:get_suffix(n)
    return ""
end

function Notation:format(n, places, places1000)
    local p = places or 0
    if n < Big:new(1000) then
        p = places1000 or 0
    end

    return self:get_prefix(n) .. self:get_number(n, p) .. self.get_suffix(n)
end

-- wrapper function to format numbers
function Notation:format_mantissa(number, places)
    return string.format("%."..places.."f", number)
end

return Notation