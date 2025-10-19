BaseStandardNotation = dofile("notations/basestandardnotation.lua")

---@class StandardNotation: BaseStandardNotation
StandardNotation = BaseStandardNotation:new()

---@param opt? BaseStandardNotationOpts
---@return StandardNotation
function StandardNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        start = {"", "K", "M", "B", "T"},
        ones = {"", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"},
        tens = {"", "Dc", "Vg", "Tg", "Qag", "Qig", "Sxg", "Spg", "Ocg", "Nog"},
        hundreds = {"", "C", "DC", "TC", "QaC", "QiC", "SxC", "SpC", "OC", "NoC"},
        dynamic = opt.dynamic,
        reversed = opt.reversed
    }, self)
end


return StandardNotation
