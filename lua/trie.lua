-- Copyright 2023 Clément Joly <foss@131719.xyz>

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.






 local function new()



 local children = {}
 local val = nil

 local function fennelview()

 local found, fennel = pcall(require, "fennel")
 if found then
 return ("#trie" .. fennel.view({children = children, value = val})) else
 return error("fennel is required to view the content of the trie. Please install fennel-lang.org as a Lua library") end end

 local function get_value(path)

 local _2_ = path if ((_G.type(_2_) == "table") and (nil ~= (_2_)[1])) then local head = (_2_)[1] local tail = {select(2, (table.unpack or _G.unpack)(_2_))}
 local subtrie do local t_3_ = children if (nil ~= t_3_) then t_3_ = (t_3_)[head] else end subtrie = t_3_ end
 if subtrie then
 return subtrie["get-value"](tail) else
 return nil end elseif (_G.type(_2_) == "table") then
 return val else return nil end end

 local function set_value(path, value)

 if (value == nil) then
 return nil else
 local _7_ = path if ((_G.type(_7_) == "table") and (nil ~= (_7_)[1])) then local head = (_7_)[1] local tail = {select(2, (table.unpack or _G.unpack)(_7_))}
 local subtrie local function _8_() local t_9_ = children if (nil ~= t_9_) then t_9_ = (t_9_)[head] else end return t_9_ end subtrie = (_8_() or new())
 do end (children)[head] = subtrie
 return subtrie["set-value"](tail, value) elseif (_G.type(_7_) == "table") then
 val = value return nil else return nil end end end

 local function get_deepest_path(path, value)

 local _13_, _14_ = path, value if (((_G.type(_13_) == "table") and (nil ~= (_13_)[1])) and (_14_ == value)) then local head = (_13_)[1]
 if (get_value(path) == value) then return path else

 table.remove(path)
 return get_deepest_path(path, value) end elseif ((_G.type(_13_) == "table") and (_14_ == val)) then
 return {} elseif true then local _ = _13_
 return nil else return nil end end

 return setmetatable({["get-value"] = get_value, ["set-value"] = set_value, ["get-deepest-path"] = get_deepest_path}, {__fennelview = fennelview}) end


 return {new = new}
