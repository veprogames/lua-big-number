BaseLetterNotation = dofile("notations/baseletternotation.lua")

---@class CyrillicNotation: BaseLetterNotation
CyrillicNotation = {}
CyrillicNotation.__index = LetterNotation
setmetatable(CyrillicNotation, BaseLetterNotation)
CyrillicNotation.__tostring = function () return "CyrillicNotation" end


---@param opt { dynamic: boolean, reversed: boolean }
---@return CyrillicNotation
function CyrillicNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~абвгдежзиклмнопстуфхцчшщэюяАБВГДЕЖЗИКЛМНОПСТУФХЦЧШЩЭЮЯ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, CyrillicNotation)
end


return CyrillicNotation
