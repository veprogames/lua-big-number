Notation = dofile("notations/notation.lua")

ThousandNotation = {}
ThousandNotation.__index = ThousandNotation
ThousandNotation.__tostring = function ()
    return "ThousandNotation"
end
setmetatable(ThousandNotation, Notation)

function ThousandNotation:new()
    return setmetatable({}, ThousandNotation)
end

function ThousandNotation:get_number(n, places)
    local raw = self.format_mantissa(n:to_number(), places)
    local result = ""
    local comma, _ = string.find(raw, "%.") - 1
    if comma == nil then comma = #raw end
    for i = 1, #raw do
        result = result .. string.sub(raw, i, i)
        if (comma - i) % 3 == 0 and i < comma then
            result = result .. ","
        end
    end
    return result
end

return ThousandNotation