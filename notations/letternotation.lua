BaseLetterNotation = dofile("notations/baseletternotation.lua")

---@class LetterNotation: BaseLetterNotation
LetterNotation = {}
LetterNotation.__index = LetterNotation
setmetatable(LetterNotation, BaseLetterNotation)
LetterNotation.__tostring = function () return "LetterNotation" end


---@param opt { dynamic: boolean, reversed: boolean }
---@return LetterNotation
function LetterNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, LetterNotation)
end

return LetterNotation
