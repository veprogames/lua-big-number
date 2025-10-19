BaseLetterNotation = require "notations.baseletternotation"

---@class LetterNotation: BaseLetterNotation
LetterNotation = BaseLetterNotation:new()


---@param opt { dynamic: boolean, reversed: boolean }
---@return LetterNotation
function LetterNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        letters = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, self)
end

return LetterNotation
