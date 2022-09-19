Notation = dofile("notations/notation.lua")

DynamicNotation = {}
DynamicNotation.__index = DynamicNotation
DynamicNotation.__tostring = function ()
    return "DynamicNotation"
end

function DynamicNotation:new(opt)
    return setmetatable({
        small = opt.small, --nil for just float formatting
        big = opt.big,
        limit = opt.limit
    }, DynamicNotation)
end

function DynamicNotation:get_notation(n)
    return self.big
    --if n <= self.limit then return self.small else return self.big end
end

function DynamicNotation:get_prefix(n)
    if self.small == nil and n <= self.limit then return "" end
    return self:get_notation(n):get_prefix(n)
end

function DynamicNotation:get_number(n, places)
    if self.small == nil and n <= self.limit then
        return Notation.format_mantissa(n:to_number(), places)
    end
    return self:get_notation(n):get_number(n, places)
end

function DynamicNotation:get_suffix(n)
    if self.small == nil and n <= self.limit then return "" end
    return self:get_notation(n):get_suffix(n)
end

function DynamicNotation:format(n, places_big, places_small)
    local p = 0
    if n <= self.limit then 
        p = places_small or 0
    else
        p = places_big or 0
    end
    
    return self:get_prefix(n) .. self:get_number(n, p) .. self:get_suffix(n)
end

return DynamicNotation