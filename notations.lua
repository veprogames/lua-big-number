Notations = { Components = {} }

---Configuration for SequenceByNth and Sequence
---@class SequenceParams
---The Units that will be used. If it is a string,
---every character is a unit.
---@field sequence string|string[]
---If descending, the higher order units come
---first. Example: ab, ac, ad, ae, ...
---
---If ascending, the lower order units come
---first. Example: ba, ca, da, ea, ...
---@field order "ascending"|"descending"?


---Return the Sequence for the `nth` "order"
---of a notation.
---
---For example, in a letter notation, 0 is a,
---1 is b and so on.
---@param nth number
---@param params SequenceParams
---@return string
function Notations.Components.SequenceByNth(nth, params)
    local sequence = params.sequence
    local order = params.order or "descending"

    local result = ""
    while nth > 0 do
        local str_index = 1 + nth % #sequence

        local str
        if type(sequence) == "table" then
            str = sequence[str_index]
        else
            str = sequence:sub(str_index, str_index)
        end

        if order == "descending" then
            result = str .. result
        elseif order == "ascending" then
            result = result .. str
        else
            error(order .. " is an invalid order!")
        end

        nth = math.floor(nth / #sequence)
    end
    return result
end


---Return the sequence for a number. This
---assumes base 1000.
---
---For example, in a sequence " abc", 1-999 is "",
---1,000-999,999 is "a", 1,000,000-999,999,999 is "b" and so on.
---@param n Big
---@param params SequenceParams
---@return string
function Notations.Components.Sequence(n, params)
    local nth = math.floor(n.e / 3)
    return Notations.Components.SequenceByNth(nth, params)
end


---Configure the Mantissa
---@class MantissaParams
---@field precision number? Significant digits
---The logarithm of the base. The base describes
---when the notation enters the next "order",
---causing the mantissa to divide to 1.
---
---The default is 3, which translates to 10 ^ 3 = 1000,
---a common case for notations.
---
---Example:
---
---1. 999 K + 2 K = 1,001 K
---2. Base is 1,000. 1,001 > 1,000
---3. Divide by 1,000 -> 1.001 M
---@field base_e number?


---Return the mantissa part of a notation.
---For example, in 123.45 Million, 123.45
---is the mantissa.
---@param n Big
---@param params? MantissaParams
---@return string
function Notations.Components.Mantissa(n, params)
    params = params or {}
    local base_e = params.base_e or 3.0
    local precision = params.precision or 0

    if n.m < 0 then
        return "-" .. Notations.Mantissa(-n, params)
    end

    local value = n.m * 10 ^ (n.e % base_e)
    return string.format("%." .. precision .. "f", value)
end


---Return a suffix for a standard notation:
---K, M, B, T, Qa and so on.
---@param n Big
---@return string
function Notations.Components.StandardSuffix(n)
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


---Configure the exponential suffix `e<x>`,
---where x is a number
---@class ExponentialSuffixParams
---Snap the exponent to `base_e`. Common values
---are 1 for scientific or 3 for engineering.
---@field base_e number


---Return the exponential suffix `e<x>` for `n`,
---where x is a number
---@param n Big
---@param params ExponentialSuffixParams
---@return string
function Notations.Components.ExponentialSuffix(n, params)
    local base_e = math.floor(params.base_e)

    local e = math.floor(n.e / base_e) * base_e

    return "e" .. e
end


---Letter Notation: a, b, .., z, a~, aa, ab, ..
---@param n Big
---@return string
function Notations.Letters(n)
    return Notations.Components.Mantissa(n, { precision = 2 }) .. Notations.Components.Sequence(n, { sequence = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" })
end


---Letter Notation with the Greek alphabet
---@param n Big
---@return string
function Notations.Greek(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Components.Sequence(n, { sequence = "~αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ" })
end


---Letter Notation with the Hebrew alphabet
---@param n Big
---@return string
function Notations.Hebrew(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Components.Sequence(n, { sequence = "~אבּבגּגדּדהוזחטיכּכךּךלמםנןסעפּפףּףצץקרשׁשׂתּת" })
end


---Letter Notation with the Cyrillic alphabet
---@param n Big
---@return string
function Notations.Cyrillic(n)
    return Notations.Mantissa(n, { precision = 2 }) .. Notations.Components.Sequence(n, { sequence = "~абвгдежзиклмнопстуфхцчшщэюяАБВГДЕЖЗИКЛМНОПСТУФХЦЧШЩЭЮЯ" })
end


---Configure the notation for
---thousand-separated numbers
---@class ThousandNotationParams
---@field precision number? Significant digits


---Return a number with thousand separators,
---for example 1234567 -> 1,234,567
---@param n Big
---@param params ThousandNotationParams?
---@return string
function Notations.Thousand(n, params)
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


---Standard Notation: 1.00, 1.00 K, 1.00 M, .., 1.00 QaDc, 1.00 QiDc, ..
---@param n Big
---@return string
function Notations.Standard(n)
    return Notations.Components.Mantissa(n, { precision = 2 }) .. " " .. Notations.Components.StandardSuffix(n)
end


---Scientific Notation: 1.00e0, 1.00e1, 1.00e2, 1.00e3, 1.00e4, ..
---@param n Big
---@return string
function Notations.Scientific(n)
    return Notations.Components.Mantissa(n, { precision = 2, base_e = 1 }) ..
        Notations.Components.ExponentialSuffix(n, { base_e = 1 })
end


---Engineering Notation: 1.00e0, 10.00e0, 100.00e0, 1.00e3, 10.00e3, ..
---@param n Big
---@return string
function Notations.Engineering(n)
    return Notations.Components.Mantissa(n, { precision = 2 }) ..
        Notations.Components.ExponentialSuffix(n, { base_e = 3 })
end


return Notations
