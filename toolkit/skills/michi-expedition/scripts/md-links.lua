-- Rewrite relative links for the HTML copy of a page.
-- Paths are worked out from the repo root: a link to a library page (or to a root doc that has an
-- HTML copy, such as ARCHITECTURE.md) points at its .html; any other link points at the file in the
-- repo, relative to where the HTML page sits.
-- Images point at the file in the repo the same way, except the page's own rendered diagrams
-- (<page_name>-<n>.svg), which the build copies beside the HTML page.
-- Metadata: page_repo_dir (the source's folder), html_repo_dir (the HTML page's folder),
-- library_dir, page_name, and page_map, the pages whose HTML name isn't their markdown name
-- ("docs/library/tldr.md=index.html,ARCHITECTURE.md=architecture.html").
local page_repo_dir, html_repo_dir, library_dir, page_name = "", "", "", ""
local page_map = {}

local function split(path)
  local parts = {}
  for part in path:gmatch("[^/]+") do
    parts[#parts + 1] = part
  end
  return parts
end

local function normalize(path)
  local out = {}
  for _, part in ipairs(split(path)) do
    if part == ".." and #out > 0 and out[#out] ~= ".." then
      table.remove(out)
    elseif part ~= "." then
      out[#out + 1] = part
    end
  end
  return table.concat(out, "/")
end

local function relative(from_dir, to)
  local from, dest = split(normalize(from_dir)), split(normalize(to))
  local i = 1
  while i <= #from and i <= #dest and from[i] == dest[i] do
    i = i + 1
  end
  local parts = {}
  for _ = i, #from do
    parts[#parts + 1] = ".."
  end
  for j = i, #dest do
    parts[#parts + 1] = dest[j]
  end
  return #parts == 0 and "." or table.concat(parts, "/")
end

local function html_copy_of(path)
  if page_map[path] then
    return library_dir .. "/html/" .. page_map[path]
  end
  local prefix = library_dir .. "/"
  if path:sub(1, #prefix) == prefix and path:match("%.md$") then
    local inside = path:sub(#prefix + 1)
    if not inside:match("^html/") then
      return library_dir .. "/html/" .. (inside:gsub("%.md$", ".html"))
    end
  end
  return nil
end

function Meta(meta)
  local function read(key)
    return meta[key] and pandoc.utils.stringify(meta[key]) or ""
  end
  page_repo_dir, html_repo_dir, library_dir = read("page_repo_dir"), read("html_repo_dir"), read("library_dir")
  page_name = read("page_name")
  for source, page in read("page_map"):gmatch("([^,=]+)=([^,]+)") do
    page_map[source] = page
  end
end

function Link(link)
  local target = link.target
  if target == "" or target:match("^%a[%w+.-]*:") or target:match("^#") or target:match("^/") then
    return link
  end
  local path, fragment = target:match("^([^#]*)(.*)$")
  local resolved = normalize(page_repo_dir .. "/" .. path)
  link.target = relative(html_repo_dir, html_copy_of(resolved) or resolved) .. fragment
  return link
end

local function is_rendered_diagram(src)
  local file = src:gsub("^%./", "")
  return page_name ~= "" and file:sub(1, #page_name + 1) == page_name .. "-" and file:match("^[^/]*%-%d+%.svg$") ~= nil
end

function Image(image)
  local src = image.src
  if src == "" or src:match("^%a[%w+.-]*:") or src:match("^/") or is_rendered_diagram(src) then
    return image
  end
  image.src = relative(html_repo_dir, normalize(page_repo_dir .. "/" .. src))
  return image
end

return { { Meta = Meta }, { Link = Link, Image = Image } }
