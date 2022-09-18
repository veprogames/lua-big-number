BaseNotation = dofile("notations/basenotation.lua")

BaseLetterNotation = {
    letters = ""
}
BaseLetterNotation.__index = BaseLetterNotation
BaseLetterNotation.__tostring = function (notation)
    return "BaseLetterNotation {"..notation.letters.."}"
end
setmetatable(BaseLetterNotation, BaseNotation)

function BaseLetterNotation:new(letters)
    return setmetatable({letters = letters}, BaseLetterNotation)
end

function BaseLetterNotation:get_suffix(n)
    return "abc"
end

return BaseLetterNotation