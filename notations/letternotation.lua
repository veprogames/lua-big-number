BaseLetterNotation = dofile("notations/baseletternotation.lua")

LetterNotation = {}
LetterNotation.__index = LetterNotation
setmetatable(LetterNotation, BaseLetterNotation)

function LetterNotation:new()
    return setmetatable({letters = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"}, LetterNotation)
end

return LetterNotation