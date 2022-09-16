-- class table
Big = {
    m = 0,
    e = 0
}

-- metatable
BigMeta = {}
BigMeta.__index = Big

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

function Big:sub(b)
    local nb = Big:new(b.m * -1, b.e) --negate b
    return self:add(nb)
end

function Big:mul(b)
    return Big:new(self.m * b.m, self.e + b.e):normalized()
end

function Big:div(b)
    return Big:new(self.m / b.m, self.e - b.e):normalized()
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

function Big:sqrt()
    return self:pow(0.5)
end

function Big:cbrt()
    return self:pow(1 / 3)
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

function Big:lte(b)
    return self:compare(b) <= 0
end

function Big:gt(b)
    return self:compare(b) == 1
end

function Big:eq(b)
    return self:compare(b) == 0
end

function Big:to_string()
    return self.m.."e"..self.e
end

function Big:to_number()
    return self.m * 10 ^ self.e
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