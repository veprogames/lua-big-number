BaseLetterNotation = require "notations.baseletternotation"

---@class GreekNotation: BaseLetterNotation
GreekNotation = BaseLetterNotation:new()


---@param opt { dynamic: boolean, reversed: boolean }
---@return GreekNotation
function GreekNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        letters = "~αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, self)
end


function GreekNotation.__tostring()
    return "GreekNotation"
end


return GreekNotation
