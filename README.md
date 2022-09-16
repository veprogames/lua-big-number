# lua-big-number

A simple big number library for Lua, inspired by https://github.com/Patashu/break_infinity.js

## Usage

1. Add `bignumber.lua` into your project
2. `Big = dofile("/path/to/bignumber.lua")`

## Example

```lua
Big = dofile("/path/to/bignumber.lua")

local big1 = Big:new(100)
local big2 = Big:new(10)
local added = big1:add(big2)
print(added:to_string()) -- will output 1.1e2 
```