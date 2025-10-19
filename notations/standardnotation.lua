BaseStandardNotation = dofile("notations/basestandardnotation.lua")


---@class StandardNotation: BaseStandardNotation
StandardNotation = {}
StandardNotation.__index = StandardNotation
StandardNotation.__tostring = function (notation)
    return "StandardNotation"
end
setmetatable(StandardNotation, BaseStandardNotation)


---@param opt BaseStandardNotationOpts
---@return StandardNotation
function StandardNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        start = {"", "K", "M", "B", "T"},
        ones = {"", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"},
        tens = {"", "Dc", "Vg", "Tg", "Qag", "Qig", "Sxg", "Spg", "Ocg", "Nog"},
        hundreds = {"", "C", "DC", "TC", "QaC", "QiC", "SxC", "SpC", "OC", "NoC"},
        dynamic = opt.dynamic,
        reversed = opt.reversed
    }, StandardNotation)
end


return StandardNotation
