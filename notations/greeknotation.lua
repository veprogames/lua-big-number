BaseLetterNotation = dofile("notations/baseletternotation.lua")

---@class GreekNotation: BaseLetterNotation
GreekNotation = {}
GreekNotation.__index = LetterNotation
setmetatable(GreekNotation, BaseLetterNotation)
GreekNotation.__tostring = function () return "GreekNotation" end


---@param opt { dynamic: boolean, reversed: boolean }
---@return GreekNotation
function GreekNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, GreekNotation)
end


return GreekNotation
