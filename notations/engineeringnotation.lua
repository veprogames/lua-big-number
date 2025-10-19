Notation = require "notations.notation"

---@class EngineeringNotation: Notation
EngineeringNotation = {}


---@param opt? { dynamic: boolean }
function EngineeringNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        dynamic = opt.dynamic or false
    }, self)
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


function EngineeringNotation.__tostring()
    return "EngineeringNotation"
end


return EngineeringNotation
