Notation = dofile("notations/notation.lua")

---@class ThousandNotation: Notation
ThousandNotation = {}
ThousandNotation.__index = ThousandNotation
ThousandNotation.__tostring = function ()
    return "ThousandNotation"
end
setmetatable(ThousandNotation, Notation)


---@return ThousandNotation
function ThousandNotation.new()
    return setmetatable({}, ThousandNotation)
end



---@param n Big
---@param places number
---@return string
function ThousandNotation:get_number(n, places)
    local raw = self.format_mantissa(n:to_number(), places)
    local result = ""
    local comma = string.find(raw, "%.")

    if comma == nil then
        comma = #raw
    else
        comma = comma - 1
    end

    for i = 1, #raw do
        result = result .. string.sub(raw, i, i)
        if (comma - i) % 3 == 0 and i < comma then
            result = result .. ","
        end
    end
    return result
end


return ThousandNotation
