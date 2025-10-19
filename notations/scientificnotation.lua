Notation = dofile("notations/notation.lua")

---@class ScientificNotation: Notation
ScientificNotation = {}
ScientificNotation.__index = ScientificNotation
ScientificNotation.__tostring = function ()
    return "ScientificNotation"
end
setmetatable(ScientificNotation, Notation)


---@return ScientificNotation
function ScientificNotation.new()
    return setmetatable({}, ScientificNotation)
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


return ScientificNotation
