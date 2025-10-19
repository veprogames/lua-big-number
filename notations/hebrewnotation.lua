BaseLetterNotation = dofile("notations/baseletternotation.lua")

---@class HebrewNotation: BaseLetterNotation
HebrewNotation = BaseLetterNotation:new()


---@param opt? { dynamic: boolean, reversed: boolean }
---@return HebrewNotation
function HebrewNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        letters = "~אבּבגּגדּדהוזחטיכּכךּךלמםנןסעפּפףּףצץקרשׁשׂתּת",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, self)
end


function HebrewNotation.__tostring()
    return "HebrewNotation"
end


return HebrewNotation
