BaseLetterNotation = require "notations.baseletternotation"

---@class CyrillicNotation: BaseLetterNotation
CyrillicNotation = BaseLetterNotation:new()


---@param opt? { dynamic: boolean, reversed: boolean }
---@return CyrillicNotation
function CyrillicNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        letters = "~абвгдежзиклмнопстуфхцчшщэюяАБВГДЕЖЗИКЛМНОПСТУФХЦЧШЩЭЮЯ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, self)
end


return CyrillicNotation
