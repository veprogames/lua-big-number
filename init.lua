---@class Big
---@field m number
---@field e number
---@operator unm: Big
---@operator add: Big
---@operator mul: Big
---@operator sub: Big
---@operator div: Big
---@operator pow: Big
Big = {}


---Create a new Big number
---
---numbers are stored in the form `m * 10 ^ e`
---@param m number
---@param e number?
---@return Big
function Big:new(m, e)
    if e == nil then e = 0 end

    if type(m) == "string" then
        local parsed = Big.parse(m)
        if parsed == nil then
            error(string.format("%s is not a valid Big number", m))
        end
        return parsed
    end

    return setmetatable({m = m, e = e}, self):normalized()
end


---Ensure that 1.0 <= m < 10.0
---
---The number is modified in place
---@private
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


---Ensure that 1.0 <= m < 10.0
---
---A new number is returned
---@private
---@return Big
function Big:normalized()
    self:normalize()
    return self
end


---Add b to self, returning a new instance
---@param b Big
---@return Big
function Big:add(b)
    local delta = b.e - self.e

    if delta > 14 then return b end
    if delta < -14 then return self end

    return Big:new(self.m + b.m * 10 ^ delta, self.e):normalized()
end


---Substract b from self, returning a new instance
---@param b Big
---@return Big
function Big:sub(b)
    local nb = Big:new(b.m * -1, b.e) --negate b
    return self:add(nb)
end


---Multiply b onto self, returning a new instance
---@param b Big
---@return Big
function Big:mul(b)
    return Big:new(self.m * b.m, self.e + b.e):normalized()
end


---Divide self by b, returning a new instance
---@param b Big
---@return Big
function Big:div(b)
    return Big:new(self.m / b.m, self.e - b.e):normalized()
end


---Multiply self by -1, returning a new instance
---@return Big
function Big:negate()
    return self:mul(Big:new(-1))
end


---Calculate the logarithm to the base 10 of self
---@return number?
function Big:log10()
    if self:lte(Big:new(0)) then return nil end
    return self.e + math.log(self.m, 10)
end

---Calculate the logarithm to the base `base` of self
---@param base number
---@return number
function Big:log(base)
    return self:log10() / math.log(base, 10)
end


---Calculate the natural logarithm ( to the base math.exp(1) ) of self
---@return number
function Big:ln()
    return self:log(math.exp(1))
end


---Return the logarithm to the base 2 of self
---@return number
function Big:ld()
    return self:log(2)
end


---Raise self to the `pow`th power, returning a new instance
---@param pow number
---@return Big
function Big:pow(pow)
    -- faster than self:eq(Big:new(0))
    if self.m == 0 and self.e == 0 then
        return Big:new(0)
    end
    local log = self:log10()
    local new_log = log * pow
    return Big:new(10 ^ (new_log % 1), math.floor(new_log)):normalized()
end


---Calculate e^n, where e is eulers number.
---
---Returns a new instance.
---@param n number
---@return Big
function Big.exp(n)
    return Big:new(math.exp(1)):pow(n)
end


---Return a new instance of self raised
---to the power of -1, or in other words,
---1/self.
---@return Big
function Big:recp()
    return self:pow(-1)
end


---Return the square root of self
---as a new instance
---@return Big
function Big:sqrt()
    return self:pow(0.5)
end


---Return the cube root of self
---as a new instance
---@return Big
function Big:cbrt()
    return self:pow(1 / 3)
end


---If the fractional part of self
---is 0.5 or bigger, round up.
---
---If the fractional part of self
---is smaller than 0.5, round down.
---
---Returns a new instance.
---@return Big
function Big:round()
    local num = self:to_number()
    if num % 1 < 0.5 then
        return Big:new(math.floor(num))
    else
        return Big:new(math.ceil(num))
    end
end


---Returns a new instance, rounded down
---@return Big
function Big:floor()
    return Big:new(math.floor(self:to_number()))
end


---Returns a new instance, rounded up
---@return Big
function Big:ceil()
    return Big:new(math.ceil(self:to_number()))
end


---Returns a new instance where
---the mantissa part is rounded down.
---
---Examples for digits == 1:
---
---* 1234 -> 1200
---* 1.23 -> 1.2
---* 0.00456 -> 0.0045
---@param digits number Significant digits
---@return Big
function Big:floor_m(digits)
    return Big:new(math.floor(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end


---Returns a new instance where
---the mantissa part is rounded up.
---
---Examples for digits == 1:
---
---* 1234 -> 1300
---* 1.23 -> 1.3
---* 0.00456 -> 0.0046
---@param digits number Significant digits
---@return Big
function Big:ceil_m(digits)
    return Big:new(math.ceil(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end


---Return the sine of self
---as a new instance.
---@return Big
function Big:sin()
    return Big:new(math.sin(self:to_number()))
end


---Return the inverse sine of self
---as a new instance.
---@return Big
function Big:asin()
    return Big:new(math.asin(self:to_number()))
end


---Return the cosine of self
---as a new instance.
---@return Big
function Big:cos()
    return Big:new(math.cos(self:to_number()))
end


---Return the inverse cosine of self
---as a new instance.
---@return Big
function Big:acos()
    return Big:new(math.acos(self:to_number()))
end


---Return the tangent of self
---as a new instance.
---@return Big
function Big:tan()
    return Big:new(math.tan(self:to_number()))
end


---Return true if self >= 0
---@return boolean
function Big:is_positive()
    return self.m >= 0
end


---Return true if self < 0
---@return boolean
function Big:is_negative()
    return self.m < 0
end


---Returns 1 if self is bigger than b.
---Returns -1 if self is smaller than b.
---Returns 0 if self is equal to b or
---on edge cases.
---
---This function is used for public
---compare methods.
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


---Returns true if self > b
---@param b Big
---@return boolean
function Big:gt(b)
    return self:compare(b) == 1
end


---Returns true if self >= b
---@param b Big
---@return boolean
function Big:gte(b)
    return self:compare(b) >= 0
end


---Returns true if self < b
---@param b Big
---@return boolean
function Big:lt(b)
    return self:compare(b) == -1
end


---Returns true if self <= b
---@param b Big
---@return boolean
function Big:lte(b)
    return self:compare(b) <= 0
end


---Returns true if self equals b
---@param b Big
---@return boolean
function Big:eq(b)
    return self:compare(b) == 0
end


---Returns true if self does not equal b
---@param b Big
---@return boolean
function Big:neq(b)
    return self:compare(b) ~= 0
end


---Returns a string representation
---in the form of `m`e`e`
---@return string
function Big:to_string()
    return self.m.."e"..self.e
end


---Converts self into a number
---@return number
function Big:to_number()
    return self.m * 10 ^ self.e
end


---Return a new Big instance from
---a string. The string must be
---in the format of `m`e`e`,
---where m and e are valid
---numbers.
---
---This is the inverse function
---to Big:to_string(), so
---`b == Big.parse(b:to_string())`
---@param str string Representation of a number as `m`e`e`
---@return Big?
function Big.parse(str)
    local to_n = tonumber(str)
    if to_n ~= nil and to_n < math.huge then
        return Big:new(to_n):normalized()
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

    return Big:new(mantissa, math.floor(exponent)):normalized()
end


Big.__index = Big
Big.__add = Big.add
Big.__sub = Big.sub
Big.__mul = Big.mul
Big.__div = Big.div
Big.__pow = Big.pow
Big.__unm = Big.negate
Big.__le = Big.lte
Big.__lt = Big.lt
Big.__eq = Big.eq
Big.__tostring = Big.to_string


return Big
