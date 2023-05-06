-- Copyright 2023 Clément Joly <foss@131719.xyz>

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
local function new()
  local self = {children = {}, val = nil}
  local function fennelview()
    local found, fennel = pcall(require, "fennel")
    if found then
      return ("#trie" .. fennel.view(self))
    else
      return error("fennel is required to view the content of the trie. Please install fennel-lang.org as a Lua library")
    end
  end
  local function get_value(path)
    local _2_ = path
    if ((_G.type(_2_) == "table") and (nil ~= (_2_)[1])) then
      local head = (_2_)[1]
      local tail = {select(2, (table.unpack or _G.unpack)(_2_))}
      local subtrie
      do
        local t_3_ = self
        if (nil ~= t_3_) then
          t_3_ = (t_3_).children
        else
        end
        if (nil ~= t_3_) then
          t_3_ = (t_3_)[head]
        else
        end
        subtrie = t_3_
      end
      if subtrie then
        return subtrie["get-value"](tail)
      else
        return nil
      end
    elseif (_G.type(_2_) == "table") then
      return self.val
    else
      return nil
    end
  end
  local function set_value(path, value)
    if (value == nil) then
      return nil
    else
      local _8_ = path
      if ((_G.type(_8_) == "table") and (nil ~= (_8_)[1])) then
        local head = (_8_)[1]
        local tail = {select(2, (table.unpack or _G.unpack)(_8_))}
        local subtrie
        local function _9_()
          local t_10_ = self
          if (nil ~= t_10_) then
            t_10_ = (t_10_).children
          else
          end
          if (nil ~= t_10_) then
            t_10_ = (t_10_)[head]
          else
          end
          return t_10_
        end
        subtrie = (_9_() or new())
        do end (self)["children"][head] = subtrie
        return subtrie["set-value"](tail, value)
      elseif (_G.type(_8_) == "table") then
        self["val"] = value
        return nil
      else
        return nil
      end
    end
  end
  local function get_deepest_path(path, value)
    local _15_, _16_ = path, value
    if (((_G.type(_15_) == "table") and (nil ~= (_15_)[1])) and (_16_ == value)) then
      local head = (_15_)[1]
      if (get_value(path) == value) then
        return path
      else
        table.remove(path)
        return get_deepest_path(path, value)
      end
    elseif ((_G.type(_15_) == "table") and (_16_ == self.val)) then
      return {}
    elseif true then
      local _ = _15_
      return nil
    else
      return nil
    end
  end
  return setmetatable({["get-value"] = get_value, ["set-value"] = set_value, ["get-deepest-path"] = get_deepest_path}, {__fennelview = fennelview})
end
return {new = new}
