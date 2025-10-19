Notation = dofile("notations/notation.lua")

---@class BaseStandardNotation: Notation
---@field start string[]
---@field ones string[]
---@field tens string[]
---@field hundreds string[]
---@field reversed boolean
BaseStandardNotation = Notation:new()


---@class BaseStandardNotationOpts
---@field start string[]
---@field ones string[]
---@field tens string[]
---@field hundreds string[]
---@field dynamic boolean
---@field reversed boolean


---@param opt? BaseStandardNotationOpts
---@return BaseStandardNotation
function BaseStandardNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        start = opt.start,
        ones = opt.ones,
        tens = opt.tens,
        hundreds = opt.hundreds,
        dynamic = opt.dynamic,
        reversed = opt.reversed
    }, self)
end


---@param e number
---@return string
function BaseStandardNotation:get_number_name(e)
    if e >= 3003 then
        local order_m = math.floor(e / 3000)
        return string.format("[%d]-MI-", order_m) .. self:get_number_name(e - 3000 * order_m)
    end

    local order = math.floor(e / 3)

    if order < #self.start then
        return self.start[1 + order]
    end

    order = order - 1
    local order_ten = math.floor(order / #self.ones)
    local order_hundred = math.floor(order_ten / #self.tens)

    return self.hundreds[1 + order_hundred % #self.hundreds] ..
        self.ones[1 + order % #self.ones] ..
        self.tens[1 + order_ten % #self.tens]
end


---@param n Big
---@param places number
---@return string
function BaseStandardNotation:get_number(n, places)
    local num = n.m * 10 ^ (n.e % 3)
    return Notation.format_mantissa(num, places)
end


---@param n Big
---@return string
function BaseStandardNotation:get_prefix(n)
    if self.reversed then return self:get_number_name(n.e) else return "" end
end


---@param n Big
---@return string
function BaseStandardNotation:get_suffix(n)
    if not self.reversed then return self:get_number_name(n.e) else return "" end
end


function BaseStandardNotation.__tostring()
    return "BaseStandardNotation"
end


return BaseStandardNotation
