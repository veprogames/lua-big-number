Notation = dofile("notations/notation.lua")

BaseLetterNotation = {
    letters = ""
}
BaseLetterNotation.__index = BaseLetterNotation
BaseLetterNotation.__tostring = function (notation)
    return "BaseLetterNotation {"..notation.letters.."}"
end
setmetatable(BaseLetterNotation, Notation)

function BaseLetterNotation:new(letters)
    return setmetatable({letters = letters}, BaseLetterNotation)
end

function BaseLetterNotation:get_number(n, places)
    local num = n.m * 10 ^ (n.e % 3)
    return Notation:format_mantissa(num, places)
end

function BaseLetterNotation:get_suffix(n)
    local order = math.floor(n.e / 3)
    local result = ""
    while order > 0 do
        local letter_index = 1 + order % #self.letters
        result = self.letters:sub(letter_index, letter_index) .. result
        order = math.floor(order / #self.letters)
    end
    return result
end

return BaseLetterNotation