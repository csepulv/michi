-- Rewrite relative links for the HTML copy of a page.
-- Paths are worked out from the repo root: a link to a library page (or to a root doc that has an
-- HTML copy, such as ARCHITECTURE.md) points at its .html; any other link points at the file in the
-- repo, relative to where the HTML page sits.
-- Images point at the file in the repo the same way, except the page's own rendered diagrams
-- (<page_name>-<n>.svg), which the build copies beside the HTML page.
-- In an edition, only the edition's pages are link targets. A link to a library document the
-- edition leaves out becomes plain text, and a list item whose every link is like that is dropped.
-- Outside a private edition, a link to anything else is recorded as leaving the bundle (the build
-- fails on it), and images are recorded for the build to copy into the bundle's assets/.
-- Metadata: page_repo_dir (the source's folder), html_repo_dir (the HTML page's folder),
-- library_dir, out_dir (the HTML folder), page_name, page_source, and page_map, the pages whose HTML
-- name isn't their markdown name ("docs/library/tldr.md=index.html,ARCHITECTURE.md=architecture.html").
-- In an edition also: edition, visibility, edition_pages (every page built, in page_map's form),
-- excluded_links (repo files the sidebar lists for a role or part the edition leaves out; links to
-- them are treated like links to a left-out library document), repo_root, and report_file, where
-- records are appended: kind, page_source, detail (tab-separated). Table rows are dropped by the same
-- rule as list items.
-- No trace (every edition): edition_roles, left_out_roles, and left_out_titles. A section whose heading
-- names a left-out role, and a passage marked <!-- role: … --> … <!-- /role --> for left-out roles
-- only, are dropped; a heading left with nothing under it goes too; a link in running text to a
-- left-out document is recorded as LEFT_OUT. Last, the page's remaining text is read for a left-out
-- role's name or document title and, outside a private edition, a repo-only document; each is a TRACE.
local page_repo_dir, html_repo_dir, library_dir, out_dir, page_name, page_source = "", "", "", "", "", ""
local edition, visibility, repo_root, report_file = "", "", "", ""
local page_map, edition_pages, excluded_links = {}, {}, {}
local edition_roles, left_out_roles, left_out_titles, all_roles = {}, {}, {}, {}
local tracked_file, page_title, diagram_dir = "", "", ""
local repo_names = {}

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
    return out_dir .. "/" .. page_map[path]
  end
  local prefix = library_dir .. "/"
  if path:sub(1, #prefix) == prefix and path:match("%.md$") then
    local inside = path:sub(#prefix + 1)
    if not inside:match("^html/") then
      return out_dir .. "/" .. (inside:gsub("%.md$", ".html"))
    end
  end
  return nil
end

local function is_library_document(path)
  local prefix = library_dir .. "/"
  if path:sub(1, #prefix) ~= prefix or not path:match("%.md$") then
    return false
  end
  local inside = path:sub(#prefix + 1)
  if inside:match("^html/") or inside:match("^editions/") then
    return false
  end
  local file = io.open(repo_root .. "/" .. path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

local function report(kind, detail)
  if report_file == "" then
    return
  end
  local file = assert(io.open(report_file, "a"))
  file:write(kind .. "\t" .. page_source .. "\t" .. detail:gsub("[\t\n]", " ") .. "\n")
  file:close()
end

local function has_scheme(target)
  return target:match("^%a[%w+.-]*:") ~= nil
end

-- What a link target becomes: "keep" (unchanged), "rewrite" (with the new target), "excluded" (a
-- library document outside the edition), or "outside" (out of the bundle).
local function resolve(target)
  if target == "" or has_scheme(target) or target:match("^#") then
    return "keep"
  end
  local bundled = edition ~= "" and visibility ~= "private"
  if target:match("^/") then
    return bundled and "outside" or "keep"
  end
  local path, fragment = target:match("^([^#]*)(.*)$")
  local resolved = normalize(page_repo_dir .. "/" .. path)
  if edition == "" then
    return "rewrite", relative(html_repo_dir, html_copy_of(resolved) or resolved) .. fragment
  end
  if edition_pages[resolved] then
    return "rewrite", relative(html_repo_dir, out_dir .. "/" .. edition_pages[resolved]) .. fragment
  end
  if is_library_document(resolved) or excluded_links[resolved] then
    return "excluded"
  end
  if bundled then
    return "outside"
  end
  return "rewrite", relative(html_repo_dir, resolved) .. fragment
end

function Meta(meta)
  local function read(key)
    return meta[key] and pandoc.utils.stringify(meta[key]) or ""
  end
  page_repo_dir, html_repo_dir, library_dir = read("page_repo_dir"), read("html_repo_dir"), read("library_dir")
  out_dir = read("out_dir")
  if out_dir == "" then
    out_dir = library_dir .. "/html"
  end
  page_name, page_source = read("page_name"), read("page_source")
  edition, visibility, repo_root, report_file = read("edition"), read("visibility"), read("repo_root"), read("report_file")
  for source, page in read("page_map"):gmatch("([^,=]+)=([^,]+)") do
    page_map[source] = page
  end
  for source, page in read("edition_pages"):gmatch("([^,=]+)=([^,]+)") do
    edition_pages[source] = page
  end
  for path in read("excluded_links"):gmatch("[^,]+") do
    excluded_links[path] = true
  end
  tracked_file = read("tracked_file")
  for role in read("edition_roles"):gmatch("[^,]+") do
    edition_roles[role] = true
  end
  for role in read("left_out_roles"):gmatch("[^,]+") do
    left_out_roles[#left_out_roles + 1] = role:lower()
  end
  for role in read("all_roles"):gmatch("[^,]+") do
    all_roles[role:lower()] = true
  end
  for title in read("left_out_titles"):gmatch("[^|]+") do
    left_out_titles[#left_out_titles + 1] = title:lower()
  end
  page_title, diagram_dir = read("pagetitle"), read("diagram_dir")
  for name in read("repo_names"):gmatch("[^,]+") do
    repo_names[name] = true
  end
end

-- --- No trace: role sections and marked passages ---

local function escape_pattern(text)
  return (text:gsub("%p", "%%%0"))
end

-- The left-out role a text names, as a word ("contributor", "Contributors"), or nil.
local function names_left_out_role(text)
  local lowered = text:lower()
  for _, role in ipairs(left_out_roles) do
    if lowered:find("%f[%a]" .. escape_pattern(role) .. "s?%f[%A]") then
      return role
    end
  end
  return nil
end

-- A role name as the configuration spells it: case and a plural "s" don't matter.
local function known_role(name)
  name = name:lower()
  if all_roles[name] then
    return name
  end
  if name:sub(-1) == "s" and all_roles[name:sub(1, -2)] then
    return name:sub(1, -2)
  end
  return nil
end

-- What an HTML comment is: "start" (with its role names), "end", "bad" (a role marker that doesn't
-- parse, with "start" or "end" for what it most looks like), "comment", or nil (not a comment alone).
local function classify_comment(text)
  local body = text:match("^%s*<!%-%-(.-)%-%->%s*$")
  local looks_like_marker = text:lower():find("<!%-%-%s*/?%s*role") ~= nil
  if not body or body:find("-->", 1, true) then
    if looks_like_marker then
      return "bad", text:lower():find("<!%-%-%s*/") and "end" or "start"
    end
    return body and "comment" or nil
  end
  body = body:match("^%s*(.-)%s*$")
  local lowered = body:lower()
  if lowered == "/role" then
    return "end"
  end
  local names = lowered:match("^role:%s*(.+)$")
  if names then
    return "start", names
  end
  if lowered:match("^/?%s*role") then
    return "bad", lowered:match("^/") and "end" or "start"
  end
  return "comment"
end

-- Whether a marker's passage stays: one of its roles is in the edition. A name that isn't one of the
-- configuration's roles is an error, never a reason to keep.
local function marker_keeps(names)
  local keep = false
  for name in names:gmatch("[^,%s]+") do
    local role = known_role(name)
    if not role then
      report("MARKER", "unknown role \"" .. name .. "\" in a role marker")
    elseif edition_roles[role] then
      keep = true
    end
  end
  return keep
end

-- In an edition: drop sections whose heading (below the page title) names a left-out role, down to the
-- next heading of the same or a higher level; drop passages marked only for left-out roles; drop the
-- markers and every other HTML comment. A marker that doesn't parse, is nested, or isn't closed stops
-- the build; its passage is dropped meanwhile, so nothing it held reaches the page.
local function drop_role_blocks(blocks)
  if edition == "" then
    return nil
  end
  local kept, section_level, changed = {}, nil, false
  local open, depth = nil, 0
  for _, block in ipairs(blocks) do
    if section_level and block.t == "Header" and block.level <= section_level then
      section_level = nil
    end
    local kind, detail = nil, nil
    if block.t == "RawBlock" and block.format == "html" then
      kind, detail = classify_comment(block.text)
    end
    if kind == "bad" then
      report("MARKER", "malformed role marker: " .. block.text:gsub("%s+", " "))
      kind, detail = detail, "unparsed"
    end
    if kind == "start" then
      changed = true
      if open then
        report("MARKER", "nested role marker")
        depth = depth + 1
      else
        open = (detail ~= "unparsed" and marker_keeps(detail)) and "keep" or "drop"
      end
    elseif kind == "end" then
      changed = true
      if depth > 0 then
        depth = depth - 1
      elseif open then
        open = nil
      else
        report("MARKER", "role marker end without a start")
      end
    elseif kind == "comment" then
      changed = true
    elseif section_level then
      changed = true
    elseif open == "drop" then
      changed = true
      report("DROPPED_PASSAGE", pandoc.utils.stringify(block))
    elseif block.t == "Header" and block.level > 1 and names_left_out_role(pandoc.utils.stringify(block)) then
      section_level, changed = block.level, true
      report("DROPPED_SECTION", pandoc.utils.stringify(block))
    else
      kept[#kept + 1] = block
    end
  end
  if open then
    report("MARKER", "unclosed role marker")
  end
  return changed and kept or nil
end

-- In an edition: a role marker inside a paragraph is an error (markers go on lines of their own); what
-- it encloses is dropped. Other inline HTML comments are dropped.
local function drop_inline_markers(inlines)
  if edition == "" then
    return nil
  end
  local kept, dropping, changed = {}, false, false
  for _, inline in ipairs(inlines) do
    local kind = nil
    if inline.t == "RawInline" and inline.format == "html" then
      kind = classify_comment(inline.text)
    end
    if kind == "start" or kind == "end" or kind == "bad" then
      report("MARKER", "inline role marker; put markers on lines of their own")
      dropping = (kind == "start") or (kind == "bad" and not inline.text:find("<!%-%-%s*/"))
      changed = true
    elseif kind == "comment" or dropping then
      changed = true
    else
      kept[#kept + 1] = inline
    end
  end
  return changed and kept or nil
end

-- Headings with nothing under them in the source; the drops don't remove these.
local empty_in_source = {}
local function record_empty_headings(blocks)
  if edition == "" then
    return nil
  end
  local has_content = {}
  for i = #blocks, 1, -1 do
    local block = blocks[i]
    if block.t == "Header" then
      if not has_content[block.level] then
        empty_in_source[block.identifier] = true
      end
      for level = block.level, 6 do
        has_content[level] = false
      end
    else
      for level = 1, 6 do
        has_content[level] = true
      end
    end
  end
  return nil
end

-- In an edition: drop a heading (below the page title) whose section the other drops left empty.
local function drop_empty_sections(blocks)
  if edition == "" then
    return nil
  end
  local has_content, kept, changed = {}, {}, false
  for i = #blocks, 1, -1 do
    local block = blocks[i]
    if block.t == "Header" and block.level > 1 then
      if has_content[block.level] or empty_in_source[block.identifier] then
        table.insert(kept, 1, block)
      else
        report("DROPPED_SECTION", pandoc.utils.stringify(block) .. " (left empty)")
        changed = true
      end
      for level = block.level, 6 do
        has_content[level] = false
      end
    else
      if block.t == "Header" then
        has_content = {}
      else
        for level = 1, 6 do
          has_content[level] = true
        end
      end
      table.insert(kept, 1, block)
    end
  end
  return changed and kept or nil
end

local function links_in(item)
  local links = {}
  pandoc.Div(item):walk({
    Link = function(link)
      links[#links + 1] = link
    end,
  })
  return links
end

-- True when an item (a list item's blocks, or a table row's cells' blocks) has links and every one of
-- them points to something the edition leaves out.
local function all_links_excluded(blocks)
  local links = links_in(blocks)
  if #links == 0 then
    return false
  end
  for _, link in ipairs(links) do
    if resolve(link.target) ~= "excluded" then
      return false
    end
  end
  return true
end

-- In an edition, drop list items whose every link points to something the edition leaves out.
local function drop_excluded_items(list)
  if edition == "" then
    return nil
  end
  local kept = {}
  for _, item in ipairs(list.content) do
    if all_links_excluded(item) then
      report("DROPPED", pandoc.utils.stringify(item))
    else
      kept[#kept + 1] = item
    end
  end
  if #kept == #list.content then
    return nil
  end
  if #kept == 0 then
    return {}
  end
  list.content = kept
  return list
end

local function row_blocks(row)
  local blocks = {}
  for _, cell in ipairs(row.cells) do
    for _, block in ipairs(cell.contents) do
      blocks[#blocks + 1] = block
    end
  end
  return blocks
end

-- In an edition, drop body rows of a table by the same rule as list items. Header rows stay.
local function drop_excluded_rows(table_element)
  if edition == "" then
    return nil
  end
  local changed = false
  for _, body in ipairs(table_element.bodies) do
    local kept = {}
    for _, row in ipairs(body.body) do
      if all_links_excluded(row_blocks(row)) then
        local cells = {}
        for _, cell in ipairs(row.cells) do
          cells[#cells + 1] = pandoc.utils.stringify(cell.contents)
        end
        report("DROPPED_ROW", table.concat(cells, " | "))
        changed = true
      else
        kept[#kept + 1] = row
      end
    end
    body.body = kept
  end
  if not changed then
    return nil
  end
  for _, body in ipairs(table_element.bodies) do
    if #body.body > 0 then
      return table_element
    end
  end
  return {}
end

-- Raw HTML isn't rewritten. Outside a private edition, a relative href or src in it would leave the
-- bundle, so it is recorded as leaving.
local function check_raw_html(raw)
  if raw.format ~= "html" or edition == "" or visibility == "private" then
    return nil
  end
  for _, attribute in ipairs({ "href", "src" }) do
    for value in raw.text:gmatch("%f[%w]" .. attribute .. '%s*=%s*"([^"]*)"') do
      if value ~= "" and not has_scheme(value) and not value:match("^#") then
        report("OUTSIDE", value .. " (raw HTML)")
      end
    end
  end
  return nil
end

function Link(link)
  local kind, target = resolve(link.target)
  if kind == "rewrite" then
    link.target = target
  elseif kind == "excluded" then
    report("LEFT_OUT", link.target .. " (\"" .. pandoc.utils.stringify(link) .. "\")")
  elseif kind == "outside" then
    report("OUTSIDE", link.target)
  end
  return link
end

local function is_rendered_diagram(src)
  local file = src:gsub("^%./", "")
  return page_name ~= "" and file:sub(1, #page_name + 1) == page_name .. "-" and file:match("^[^/]*%-%d+%.svg$") ~= nil
end

function Image(image)
  local src = image.src
  if src:match("^/") and edition ~= "" and visibility ~= "private" then
    report("OUTSIDE", src)
    return image
  end
  if src == "" or has_scheme(src) or src:match("^/") or is_rendered_diagram(src) then
    return image
  end
  local resolved = normalize(page_repo_dir .. "/" .. src)
  if edition ~= "" and visibility ~= "private" then
    report("ASSET", resolved)
    image.src = relative(html_repo_dir, out_dir .. "/assets/" .. resolved)
  else
    image.src = relative(html_repo_dir, resolved)
  end
  return image
end

-- --- No trace: the check on what the page shows ---

-- The repo's tracked files and their folders (from `git ls-files`, written by the build): what only the
-- repo holds. Untracked files on disk (node_modules, build output) belong to anyone's checkout.
local tracked = nil
local function exists_in_repo(path)
  if not tracked then
    tracked = {}
    local file = tracked_file ~= "" and io.open(tracked_file, "r")
    if file then
      for line in file:lines() do
        tracked[line] = true
        local folder = line:match("^(.*)/[^/]*$")
        while folder and not tracked[folder] do
          tracked[folder] = true
          folder = folder:match("^(.*)/[^/]*$")
        end
      end
      file:close()
    end
  end
  return tracked[path] == true
end

local function is_carried(path)
  return edition_pages[path] ~= nil or edition_pages[path:gsub("/$", "")] ~= nil
end

-- A word in the text that names a document only the repo has: a tracked path, or a markdown file at the
-- repo's root other than README.md (a name every package has), that the edition doesn't carry as a page.
-- A path written from the repo root ("/docs/…") counts; one starting ./ or ../ belongs to another project.
local function repo_only(word, carried_counts)
  word = word:gsub("[.,:;]+$", "")
  local path = word:gsub("^/", "", 1)
  if not path:match("%w") or path:match("^%.%.?/") or word:find("//", 1, true) then
    return nil
  end
  local carried = not carried_counts and is_carried(path:gsub("/$", ""))
  if path:find("/", 1, true) then
    if exists_in_repo((path:gsub("/$", ""))) and not carried then
      return word
    end
  elseif path:match("%.md$") and path ~= "README.md" and exists_in_repo(path) and not carried then
    return word
  end
  return nil
end

-- A URL into the repo (a private GitHub link, say) is a trace of it, whether or not the edition carries
-- the file: its path holds the repo's name (repo_names: the folder and the origin remote) followed,
-- somewhere after, by a tracked path. Another site that happens to share a path doesn't count.
local function url_names_repo(url)
  local path = url:match("^%a[%w+.-]*://[^/]+/([^?#]*)")
  if not path then
    return false
  end
  local parts, named = split(path), false
  for i = 1, #parts do
    if repo_names[parts[i]:gsub("%.git$", "")] then
      named = true
    elseif named and repo_only(table.concat(parts, "/", i), true) then
      return true
    end
  end
  return false
end

-- Text the plain writer leaves out but the edition still ships: raw HTML (text, attributes, comments),
-- link targets, image titles, the page title, and the labels of the page's rendered diagrams.
local function hidden_text(doc)
  local parts, urls = { page_title }, {}
  local function add_html(html)
    html = html:gsub("<style.-</style>", " ")
    for value in html:gmatch('="([^"]*)"') do
      parts[#parts + 1] = value
    end
    parts[#parts + 1] = (html:gsub("<[^>]*>", " "):gsub("&[%a#%d]+;", " "))
  end
  doc:walk({
    RawBlock = function(raw)
      if raw.format == "html" then
        add_html(raw.text)
      end
    end,
    RawInline = function(raw)
      if raw.format == "html" then
        add_html(raw.text)
      end
    end,
    Link = function(link)
      if has_scheme(link.target) then
        urls[#urls + 1] = link.target
      else
        parts[#parts + 1] = link.target:gsub("[#/._-]", " ")
      end
    end,
    Image = function(image)
      parts[#parts + 1] = image.title
      if is_rendered_diagram(image.src) and diagram_dir ~= "" then
        local file = io.open(diagram_dir .. "/" .. image.src:gsub("^%./", ""), "r")
        if file then
          add_html(file:read("a"))
          file:close()
        end
      end
    end,
  })
  return table.concat(parts, "\n"), urls
end

local function has_title(lowered, title)
  local start, finish = lowered:find(title, 1, true)
  while start do
    local before, after = lowered:sub(start - 1, start - 1), lowered:sub(finish + 1, finish + 1)
    if not before:match("%a") and not after:match("%a") then
      return true
    end
    start, finish = lowered:find(title, finish + 1, true)
  end
  return false
end

-- The page's text as a reader gets it, code blocks and tables included, with words kept apart (a plain
-- concatenation would run one paragraph's last word into the next one's first).
local function check_no_trace(doc)
  if edition == "" then
    return nil
  end
  local hidden, urls = hidden_text(doc)
  local text = pandoc.write(pandoc.Pandoc(doc.blocks), "plain", { wrap_text = "none" }) .. "\n" .. hidden
  local lowered, found = text:lower(), {}
  for _, role in ipairs(left_out_roles) do
    for start, word, finish in lowered:gmatch("()%f[%a](" .. escape_pattern(role) .. "s?)%f[%A]()") do
      found[text:sub(start, finish - 1)] = true
    end
  end
  if visibility ~= "private" then
    for _, url in ipairs(urls) do
      if url_names_repo(url) then
        found[url] = true
      end
    end
  end
  for _, title in ipairs(left_out_titles) do
    if has_title(lowered, title) then
      found[title] = true
    end
  end
  if visibility ~= "private" then
    for word in text:gmatch("[%w%._%-/]+") do
      local name = repo_only(word)
      if name then
        found[name] = true
      end
    end
  end
  for term in pairs(found) do
    report("TRACE", term)
  end
  return nil
end

return {
  { Meta = Meta },
  { Blocks = record_empty_headings },
  { Blocks = drop_role_blocks, Inlines = drop_inline_markers },
  -- Top-down, so an item is judged by all its links, nested lists included, before those lists are filtered.
  {
    traverse = "topdown",
    BulletList = drop_excluded_items,
    OrderedList = drop_excluded_items,
    Table = drop_excluded_rows,
  },
  { Blocks = drop_empty_sections },
  { Link = Link, Image = Image, RawInline = check_raw_html, RawBlock = check_raw_html },
  { Pandoc = check_no_trace },
}
