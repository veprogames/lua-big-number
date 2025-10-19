Notation = dofile("notations/notation.lua")

---@class EngineeringNotation: Notation
EngineeringNotation = {}
EngineeringNotation.__index = EngineeringNotation
EngineeringNotation.__tostring = function ()
    return "EngineeringNotation"
end
setmetatable(EngineeringNotation, Notation)


---@param opt { dynamic: boolean }
function EngineeringNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        dynamic = opt.dynamic or false
    }, EngineeringNotation)
end


---@param n Big
---@param places number
---@return string
function EngineeringNotation:get_number(n, places)
    local mantissa = n.m * 10 ^ (n.e % 3)
    return self.format_mantissa(mantissa, places)
end


---@param n Big
---@return string
function EngineeringNotation:get_suffix(n)
    return "e" .. 3 * math.floor(n.e / 3)
end


return EngineeringNotation
