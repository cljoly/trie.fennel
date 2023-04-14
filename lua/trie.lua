-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
local function new(value)
  local self = {children = {}, val = value}
  local function fennelview()
    local fennel = require("fennel")
    return ("#trie" .. fennel.view(self))
  end
  local function get_value(path)
    local _1_ = path
    if ((_G.type(_1_) == "table") and (nil ~= (_1_)[1])) then
      local head = (_1_)[1]
      local tail = {select(2, (table.unpack or _G.unpack)(_1_))}
      local subtrie
      do
        local t_2_ = self
        if (nil ~= t_2_) then
          t_2_ = (t_2_).children
        else
        end
        if (nil ~= t_2_) then
          t_2_ = (t_2_)[head]
        else
        end
        subtrie = t_2_
      end
      if subtrie then
        return subtrie["get-value"](tail)
      else
        return nil
      end
    elseif (_G.type(_1_) == "table") then
      return self.val
    else
      return nil
    end
  end
  local function set_value(path, value0)
    if (value0 == nil) then
      return nil
    else
      local _7_ = path
      if ((_G.type(_7_) == "table") and (nil ~= (_7_)[1])) then
        local head = (_7_)[1]
        local tail = {select(2, (table.unpack or _G.unpack)(_7_))}
        local subtrie
        local function _8_()
          local t_9_ = self
          if (nil ~= t_9_) then
            t_9_ = (t_9_).children
          else
          end
          if (nil ~= t_9_) then
            t_9_ = (t_9_)[head]
          else
          end
          return t_9_
        end
        subtrie = (_8_() or new())
        do end (self)["children"][head] = subtrie
        return subtrie["set-value"](tail, value0)
      elseif (_G.type(_7_) == "table") then
        self["val"] = value0
        return nil
      else
        return nil
      end
    end
  end
  local function get_deepest_path(path, value0)
    local _14_, _15_ = path, value0
    if (((_G.type(_14_) == "table") and (nil ~= (_14_)[1])) and (_15_ == value0)) then
      local head = (_14_)[1]
      if (get_value(path) == value0) then
        return path
      else
        table.remove(path)
        return get_deepest_path(path, value0)
      end
    elseif ((_G.type(_14_) == "table") and (_15_ == self.val)) then
      return {}
    elseif true then
      local _ = _14_
      return nil
    else
      return nil
    end
  end
  return setmetatable({["get-value"] = get_value, ["set-value"] = set_value, ["get-deepest-path"] = get_deepest_path}, {__fennelview = fennelview})
end
return {new = new}
