Notation = dofile("notations/notation.lua")

---@class BaseLetterNotation: Notation
---@field letters string
---@field reversed boolean
BaseLetterNotation = {}
BaseLetterNotation.__index = BaseLetterNotation
BaseLetterNotation.__tostring = function (notation)
    return "BaseLetterNotation {"..notation.letters.."}"
end
setmetatable(BaseLetterNotation, Notation)


---@param opt { letters: string, dynamic: boolean, reversed: boolean }
function BaseLetterNotation.new(opt)
    opt = opt or {}
    return setmetatable({
        letters = opt.letters,
        dynamic = opt.dynamic,
        reversed = opt.reversed
    }, BaseLetterNotation)
end


---@private
---@param n Big
---@return string
function BaseLetterNotation:get_letters(n)
    local order = math.floor(n.e / 3)
    local result = ""
    while order > 0 do
        local letter_index = 1 + order % #self.letters
        result = self.letters:sub(letter_index, letter_index) .. result
        order = math.floor(order / #self.letters)
    end
    return result
end


---@param n Big
---@param places number
---@return string
function BaseLetterNotation:get_number(n, places)
    local num = n.m * 10 ^ (n.e % 3)
    return Notation.format_mantissa(num, places)
end


---@param n Big
---@return string
function BaseLetterNotation:get_prefix(n)
    if self.reversed then return self:get_letters(n) else return "" end
end


---@param n Big
---@return string
function BaseLetterNotation:get_suffix(n)
    if not self.reversed then return self:get_letters(n) else return "" end
end


return BaseLetterNotation
