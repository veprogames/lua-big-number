-- class table
Big = {
    m = 0,
    e = 0
}

-- metatable
BigMeta = {}
BigMeta.__index = Big

--- Create a new Big number
--
-- numbers are stored in the form `m * 10 ^ e`
function Big:new(m, e)
    if e == nil then e = 0 end

    if type(m) == "string" then
        return Big.parse(m)
    end

    return setmetatable({m = m, e = e}, BigMeta):normalized()
end

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

function Big:normalized()
    self:normalize()
    return self
end

function Big:add(b)
    local delta = b.e - self.e

    if delta > 14 then return b end
    if delta < -14 then return self end

    return Big:new(self.m + b.m * 10 ^ delta, self.e):normalized()
end

function BigMeta.__add(b1, b2)
    return b1:add(b2)
end

function Big:sub(b)
    local nb = Big:new(b.m * -1, b.e) --negate b
    return self:add(nb)
end

function BigMeta.__sub(b1, b2)
    return b1:sub(b2)
end

function Big:mul(b)
    return Big:new(self.m * b.m, self.e + b.e):normalized()
end

function BigMeta.__mul(b1, b2)
    return b1:mul(b2)
end

function Big:div(b)
    return Big:new(self.m / b.m, self.e - b.e):normalized()
end

function BigMeta.__div(b1, b2)
    return b1:div(b2)
end

function Big:negate()
    return self:mul(Big:new(-1))
end

function BigMeta.__unm(b1)
    return b1:negate()
end

function Big:log10()
    if self:lte(Big:new(0)) then return nil end
    return self.e + math.log(self.m, 10)
end

function Big:log(base)
    return self:log10() / math.log(base, 10)
end

function Big:ln()
    return self:log(math.exp(1))
end

function Big:ld()
    return self:log(2)
end

function Big:pow(pow)
    local log = self:log10()
    local new_log = log * pow
    return Big:new(10 ^ (new_log % 1), math.floor(new_log)):normalized()
end

function BigMeta.__pow(b1, n)
    return b1:pow(n)
end

function Big:recp()
    return self:pow(-1)
end

function Big:sqrt()
    return self:pow(0.5)
end

function Big:cbrt()
    return self:pow(1 / 3)
end

function Big:round()
    local num = self:to_number()
    if num % 1 < 0.5 then
        return Big:new(math.floor(num))
    else
        return Big:new(math.ceil(num))
    end
end

function Big:floor()
    return Big:new(math.floor(self:to_number()))
end

function Big:ceil()
    return Big:new(math.ceil(self:to_number()))
end

function Big:floor_m(digits)
    return Big:new(math.floor(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end

function Big:ceil_m(digits)
    return Big:new(math.ceil(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end

function Big:is_positive()
    return self.m >= 0
end

function Big:is_negative()
    return self.m < 0
end

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
end

function Big:gt(b)
    return self:compare(b) == 1
end

function Big:gte(b)
    return self:compare(b) >= 0
end

function Big:lt(b)
    return self:compare(b) == -1
end

function BigMeta.__lt(b1, b2)
    return b1:lt(b2)
end

function Big:lte(b)
    return self:compare(b) <= 0
end

function BigMeta.__le(b1, b2)
    return b1:lte(b2)
end

function Big:gt(b)
    return self:compare(b) == 1
end

function Big:eq(b)
    return self:compare(b) == 0
end

function BigMeta.__eq(b1, b2)
    return b1:eq(b2)
end

function Big:neq(b)
    return self:compare(b) ~= 0
end

function Big:to_string()
    return self.m.."e"..self.e
end

function Big:to_number()
    return self.m * 10 ^ self.e
end

function BigMeta.__tostring(b)
    return b:to_string()
end

function Big.parse(str)
    if tonumber(str) ~= nil then
        return Big:new(tonumber(str)):normalized()
    end

    local parts = {}
    for m, e in str:gmatch("(.+)e(.+)") do
        parts = {m, e}
    end
    return Big:new(tonumber(parts[1]), math.floor(tonumber(parts[2]))):normalized()
end

return Big