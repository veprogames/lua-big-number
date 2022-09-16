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

    local inst = setmetatable({m = m, e = e}, BigMeta)
    inst:normalize()
    return inst
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

function Big:add(b)
    local delta = b.e - self.e

    if delta > 14 then return b end
    if delta < -14 then return self end

    local result = Big:new(self.m + b.m * 10 ^ delta, self.e)
    result:normalize()
    return result
end

function Big:sub(b)
    local nb = Big:new(b.m * -1, b.e) --negate b
    return self:add(nb)
end

function Big:mul(b)
    local result = Big:new(self.m * b.m, self.e + b.e)
    result:normalize()
    return result
end

function Big:div(b)
    local result = Big:new(self.m / b.m, self.e - b.e)
    result:normalize()
    return result
end

function Big:log10()
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
    local result = Big:new(10 ^ (new_log % 1), math.floor(new_log))
    result:normalize()
    return result
end

function Big:sqrt()
    return self:pow(0.5)
end

function Big:cbrt()
    return self:pow(1 / 3)
end

function Big:to_string()
    return self.m.."e"..self.e
end

function Big:to_number()
    return self.m * 10 ^ self.e
end

return Big