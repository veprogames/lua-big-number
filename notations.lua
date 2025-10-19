Notations = {}

---@class LetterParams
---@field letters string

---@param n Big
---@param params LetterParams
---@return string
function Notations.Letters(n, params)
    local letters = params.letters
    local order = math.floor(n.e / 3)
    local result = ""
    while order > 0 do
        local letter_index = 1 + order % #letters
        result = letters:sub(letter_index, letter_index) .. result
        order = math.floor(order / #letters)
    end
    return result
end


---@class MantissaParams
---@field precision number?
---@field base_e number?


---@param n Big
---@param params? MantissaParams
---@return string
function Notations.Mantissa(n, params)
    params = params or {}
    local base_e = params.base_e or 3.0
    local precision = params.precision or 0

    if n.m < 0 then
        return "-" .. Notations.Mantissa(-n, params)
    end

    local value = n.m * 10 ^ (n.e % base_e)
    return string.format("%." .. precision .. "f", value)
end


---@param n Big
---@return string
function Notations.StandardSuffix(n)
    local start = {"", "K", "M", "B", "T"}
    local ones = {"", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"}
    local tens = {"", "Dc", "Vg", "Tg", "Qag", "Qig", "Sxg", "Spg", "Ocg", "Nog"}
    local hundreds = {"", "C", "DC", "TC", "QaC", "QiC", "SxC", "SpC", "OC", "NoC"}

    local e = n.e

    local order = math.floor(e / 3)

    if order < #start then
        return start[1 + order]
    end

    order = order - 1
    local order_ten = math.floor(order / #ones)
    local order_hundred = math.floor(order_ten / #tens)

    local order_thousands = math.floor(order_hundred / #hundreds)
    local thousand_string = ""
    if order_thousands > 1 then
        thousand_string = string.format("[%d]-MI-", order_thousands)
    elseif order_thousands == 1 then
        thousand_string = "MI-"
    end

    return thousand_string ..
        hundreds[1 + order_hundred % #hundreds] ..
        ones[1 + order % #ones] ..
        tens[1 + order_ten % #tens]
end


---@class ExponentialSuffixParams
---@field base_e number


---@param n Big
---@param params ExponentialSuffixParams
---@return string
function Notations.ExponentialSuffix(n, params)
    local base_e = math.floor(params.base_e)

    local e = math.floor(n.e / base_e) * base_e

    return "e" .. e
end


---@param n Big
---@return string
function Notations.LetterNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Letters(n, { letters = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" })
end


---@param n Big
---@return string
function Notations.GreekNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Letters(n, { letters = "~αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ" })
end


---@param n Big
---@return string
function Notations.HebrewNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Letters(n, { letters = "~אבּבגּגדּדהוזחטיכּכךּךלמםנןסעפּפףּףצץקרשׁשׂתּת" })
end


---@param n Big
---@return string
function Notations.CyrillicNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Letters(n, { letters = "~абвгдежзиклмнопстуфхцчшщэюяАБВГДЕЖЗИКЛМНОПСТУФХЦЧШЩЭЮЯ" })
end


---@class ThousandNotationParams
---@field precision number?


---@param n Big
---@param params ThousandNotationParams?
---@return string
function Notations.ThousandNotation(n, params)
    params = params or {}
    local precision = params.precision or 0

    local raw = string.format("%." .. precision .. "f", n:to_number())
    local result = ""
    local comma = string.find(raw, "%.")

    if comma == nil then
        comma = #raw
    else
        comma = comma - 1
    end

    for i = 1, #raw do
        result = result .. string.sub(raw, i, i)
        if (comma - i) % 3 == 0 and i < comma then
            result = result .. ","
        end
    end
    return result
end


---@param n Big
---@return string
function Notations.StandardNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) .. " " .. Notations.StandardSuffix(n)
end


---@param n Big
---@return string
function Notations.ScientificNotation(n)
    return Notations.Mantissa(n, { precision = 2, base_e = 1 }) ..
        Notations.ExponentialSuffix(n, { base_e = 1 })
end


---@param n Big
---@return string
function Notations.EngineeringNotation(n)
    return Notations.Mantissa(n, { precision = 2 }) ..
        Notations.ExponentialSuffix(n, { base_e = 3 })
end


return Notations
