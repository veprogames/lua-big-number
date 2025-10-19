Notation = require "notations.notation"

---@class BaseLetterNotation: Notation
---@field letters string
---@field reversed boolean
BaseLetterNotation = Notation:new()

---@param opt? { letters: string, dynamic: boolean, reversed: boolean }
---@return BaseLetterNotation
function BaseLetterNotation:new(opt)
    self.__index = self
    opt = opt or {}
    return setmetatable({
        letters = opt.letters or "",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false,
    }, self)
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


function BaseLetterNotation:__tostring()
    return "BaseLetterNotation {"..self.letters.."}"
end


return BaseLetterNotation
