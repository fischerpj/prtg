-- directory-listing.lua
--
-- Usage:
-- ::: directory-listing
-- path: data/
-- :::
--
-- Pure Lua, no lfs, no shell commands.

local List = pandoc.List

-- Pandoc ≥ 3.0 provides pandoc.system.list_directory
local function list_dir(path)
  local ok, result = pcall(pandoc.system.list_directory, path)
  if not ok then
    return { "Error: cannot read directory '" .. path .. "'" }
  end
  table.sort(result)
  return result
end

function Div(el)
  if el.classes:includes("directory-listing") then
    local path = el.attributes["path"] or el.attributes["dir"]

    if not path then
      return pandoc.Para({ pandoc.Str("Error: missing 'path:' in directory-listing block.") })
    end

    local files = list_dir(path)
    local items = List()

    for _, f in ipairs(files) do
      items:insert(pandoc.Plain(f))
    end

    return pandoc.BulletList(items)
  end
end
