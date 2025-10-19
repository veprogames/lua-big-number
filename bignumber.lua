---@class Big
---@field m number
---@field e number
---@operator unm: Big
---@operator add: Big
---@operator mul: Big
---@operator sub: Big
---@operator div: Big
---@operator pow: Big
Big = {
    m = 0,
    e = 0
}


---Create a new Big number
---
---numbers are stored in the form `m * 10 ^ e`
---@param m number
---@param e number?
---@return Big
function Big.new(m, e)
    if e == nil then e = 0 end

    if type(m) == "string" then
        local parsed = Big.parse(m)
        if parsed == nil then
            error(string.format("%s is not a valid Big number", m))
        end
        return parsed
    end

    return setmetatable({m = m, e = e}, {
        __add = Big.add,
        __sub = Big.sub,
        __mul = Big.mul,
        __div = Big.div,
        __pow = Big.pow,
        __unm = Big.negate,
        __le = Big.lte,
        __lt = Big.lt,
        __eq = Big.eq,
        __tostring = Big.to_string,
    }):normalized()
end


---@return nil
function Big:normalize()
    if self.m == 0 then
        self.e = 0
    else
        local n_log = math.floor(math.log(math.abs(self.m), 10))
        self.m = self.m / 10 ^ n_log
        self.e = self.e + n_log
        self.e = math.floor(self.e)
    end
end


---@return Big
function Big:normalized()
    self:normalize()
    return self
end


---@param b Big
---@return Big
function Big:add(b)
    local delta = b.e - self.e

    if delta > 14 then return b end
    if delta < -14 then return self end

    return Big.new(self.m + b.m * 10 ^ delta, self.e):normalized()
end


---@param b Big
---@return Big
function Big:sub(b)
    local nb = Big.new(b.m * -1, b.e) --negate b
    return self:add(nb)
end


---@param b Big
---@return Big
function Big:mul(b)
    return Big.new(self.m * b.m, self.e + b.e):normalized()
end


---@param b Big
---@return Big
function Big:div(b)
    return Big.new(self.m / b.m, self.e - b.e):normalized()
end


---@return Big
function Big:negate()
    return self:mul(Big.new(-1))
end


---@return number?
function Big:log10()
    if self:lte(Big.new(0)) then return nil end
    return self.e + math.log(self.m, 10)
end

---@param base number
---@return number
function Big:log(base)
    return self:log10() / math.log(base, 10)
end


---@return number
function Big:ln()
    return self:log(math.exp(1))
end


---@return number
function Big:ld()
    return self:log(2)
end


---@param pow number
---@return Big
function Big:pow(pow)
    -- faster than self:eq(Big.new(0))
    if self.m == 0 and self.e == 0 then
        return Big.new(0)
    end
    local log = self:log10()
    local new_log = log * pow
    return Big.new(10 ^ (new_log % 1), math.floor(new_log)):normalized()
end


---@param n number
---@return Big
function Big.exp(n)
    return Big.new(math.exp(1)):pow(n)
end


---@return Big
function Big:recp()
    return self:pow(-1)
end


---@return Big
function Big:sqrt()
    return self:pow(0.5)
end


---@return Big
function Big:cbrt()
    return self:pow(1 / 3)
end


---@return Big
function Big:round()
    local num = self:to_number()
    if num % 1 < 0.5 then
        return Big.new(math.floor(num))
    else
        return Big.new(math.ceil(num))
    end
end


---@return Big
function Big:floor()
    return Big.new(math.floor(self:to_number()))
end


---@return Big
function Big:ceil()
    return Big.new(math.ceil(self:to_number()))
end


---@param digits number
---@return Big
function Big:floor_m(digits)
    return Big.new(math.floor(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end


---@param digits number
---@return Big
function Big:ceil_m(digits)
    return Big.new(math.ceil(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end


---@return Big
function Big:sin()
    return Big.new(math.sin(self:to_number()))
end


---@return Big
function Big:asin()
    return Big.new(math.asin(self:to_number()))
end


---@return Big
function Big:cos()
    return Big.new(math.cos(self:to_number()))
end


---@return Big
function Big:acos()
    return Big.new(math.acos(self:to_number()))
end


---@return Big
function Big:tan()
    return Big.new(math.tan(self:to_number()))
end


---@return boolean
function Big:is_positive()
    return self.m >= 0
end


---@return boolean
function Big:is_negative()
    return self.m < 0
end


---@private
---@return number
function Big:compare(b)
    if self.m == b.m and self.e == b.e then
        return 0
    end

    if self:is_positive() and b:is_negative() then
        return 1
    end
    if self:is_negative() and b:is_positive() then
        return -1
    end

    if self.e > b.e then return 1 end
    if self.e < b.e then return -1 end

    if self:is_positive() and self.m > b.m then return 1 end
    if self:is_positive() and self.m < b.m then return -1 end
    if self:is_negative() and self.m > b.m then return -1 end
    if self:is_negative() and self.m < b.m then return 1 end

    return 0
end


---@param b Big
---@return boolean
function Big:gt(b)
    return self:compare(b) == 1
end


---@param b1 Big
---@param b2 Big
---@return boolean
function Big:__gt(b1, b2)
    return b1:gt(b2)
end


---@param b Big
---@return boolean
function Big:gte(b)
    return self:compare(b) >= 0
end


---@param b Big
---@return boolean
function Big:lt(b)
    return self:compare(b) == -1
end


---@param b Big
---@return boolean
function Big:lte(b)
    return self:compare(b) <= 0
end


---@param b Big
---@return boolean
function Big:eq(b)
    return self:compare(b) == 0
end


---@param b Big
---@return boolean
function Big:neq(b)
    return self:compare(b) ~= 0
end


---@return string
function Big:to_string()
    return self.m.."e"..self.e
end


---@return number
function Big:to_number()
    return self.m * 10 ^ self.e
end


---@param str string
---@return Big?
function Big.parse(str)
    local to_n = tonumber(str)
    if to_n ~= nil and to_n < math.huge then
        return Big.new(to_n):normalized()
    end

    local parts = {}
    for m, e in str:gmatch("(.+)e(.+)") do
        parts = {m, e}
        break
    end

    if #parts ~= 2 then return nil end

    local mantissa = tonumber(parts[1])
    local exponent = tonumber(parts[2])

    if mantissa == nil or exponent == nil then
        return nil
    end

    return Big.new(mantissa, math.floor(exponent)):normalized()
end


return Big
