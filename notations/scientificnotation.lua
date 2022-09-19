Notation = dofile("notations/notation.lua")

ScientificNotation = {}
ScientificNotation.__index = ScientificNotation
ScientificNotation.__tostring = function ()
    return "ScientificNotation"
end
setmetatable(ScientificNotation, Notation)

function ScientificNotation:new()
    return setmetatable({}, ScientificNotation)
end

function ScientificNotation:get_number(n, places)
    return self:format_mantissa(n.m, places)
end

function ScientificNotation:get_suffix(n)
    return "e" .. n.e
end

return ScientificNotation