---@class Notation
---@field dynamic boolean
Notation = {}


---@param opt? { dynamic: boolean }
---@return Notation
function Notation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        dynamic = opt.dynamic or false
    }, self)
end


---@param n Big
---@return string
---@diagnostic disable-next-line: unused-local
function Notation:get_prefix(n)
    return ""
end


---@param n Big
---@param places number
---@return string
---@diagnostic disable-next-line: unused-local
function Notation:get_number(n, places)
    return ""
end


---@param n Big
---@return string
---@diagnostic disable-next-line: unused-local
function Notation:get_suffix(n)
    return ""
end


---@param n Big
---@param places number
---@param places1000 number
---@return string
function Notation:format(n, places, places1000)
    if n:is_negative() then
        return "-" .. self:format(n:negate(), places, places1000)
    end

    local p = places or 0
    if n < Big:new(1000) then
        p = places1000 or 0
    end

    if self.dynamic then p = p + self.dp(n) else end

    return self:get_prefix(n) .. self:get_number(n, p) .. self:get_suffix(n)
end

---get dynamic places, added to base precision
---@param n Big
---@return number
function Notation.dp(n)
    return -(n.e % 3)
end

---wrapper function to format numbers
---@param number number
---@return string
function Notation.format_mantissa(number, places)
    places = math.max(0, places)
    return string.format("%."..places.."f", number)
end

return Notation
