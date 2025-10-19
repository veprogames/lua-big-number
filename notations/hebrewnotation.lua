BaseLetterNotation = dofile("notations/baseletternotation.lua")

---@class HebrewNotation: Notation
HebrewNotation = {}
HebrewNotation.__index = LetterNotation
setmetatable(HebrewNotation, BaseLetterNotation)
HebrewNotation.__tostring = function () return "HebrewNotation" end


---@param opt { dynamic: boolean, reversed: boolean }
---@return HebrewNotation
function HebrewNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~אבּבגּגדּדהוזחטיכּכךּךלמםנןסעפּפףּףצץקרשׁשׂתּת",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, HebrewNotation)
end


return HebrewNotation
