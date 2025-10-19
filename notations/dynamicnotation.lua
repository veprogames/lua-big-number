Notation = dofile("notations/notation.lua")
ThousandNotation = dofile("notations/thousandnotation.lua")


---@class DynamicNotation
---@field small Notation
---@field big Notation
---@field limit Big
DynamicNotation = {}


---@param opt { small: Notation, big: Notation, limit: Big }
---@return DynamicNotation
function DynamicNotation:new(opt)
    self.__index = self
    return setmetatable({
        small = opt.small or ThousandNotation.new(),
        big = opt.big,
        limit = opt.limit
    }, self)
end


---@param n Big
---@return Notation
function DynamicNotation:get_notation(n)
    if n:lte(self.limit) then
        return self.small
    end
    return self.big
end


---@param n Big
---@return string
function DynamicNotation:get_prefix(n)
    return self:get_notation(n):get_prefix(n)
end


---@param n Big
---@param places number
---@return string
function DynamicNotation:get_number(n, places)
    return self:get_notation(n):get_number(n, places)
end


---@param n Big
---@return string
function DynamicNotation:get_suffix(n)
    return self:get_notation(n):get_suffix(n)
end


---@param n Big
---@param places_big number
---@param places_small number
function DynamicNotation:format(n, places_big, places_small)
    local p = 0
    if n:lte(self.limit) then
        p = places_small or 0
    else
        p = places_big or 0
    end

    return self:get_prefix(n) .. self:get_number(n, p) .. self:get_suffix(n)
end


function DynamicNotation.__tostring()
    return "DynamicNotation"
end


return DynamicNotation
