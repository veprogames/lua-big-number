Notation = require "notations.notation"

---@class ScientificNotation: Notation
ScientificNotation = Notation:new()
setmetatable(ScientificNotation, Notation)


---@return ScientificNotation
function ScientificNotation:new()
    self.__index = self
    return setmetatable({}, self)
end


---@param n Big
---@param places number
---@return string
function ScientificNotation:get_number(n, places)
    return self.format_mantissa(n.m, places)
end


---@param n Big
---@return string
function ScientificNotation:get_suffix(n)
    return "e" .. n.e
end


function ScientificNotation.__tostring()
    return "ScientificNotation"
end


return ScientificNotation
