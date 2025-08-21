-- This lua pandoc filter adds index entries written in the pandoc document
-- into an index where a div with id 'index' is present in the document.
--
-- Index entries in the pandoc document are written as spans, with class "index".
-- For example:
--   We are talking about a [concept]{.index} here.
-- This filter will collect all such spans and create an index entry for it in the
-- div with id 'index'.
-- The index entries will be grouped by their text, and each entry will contain
-- links to the spans that refer to that entry.
-- For Latex output, it will use the default index mechanisms of latex: converting
-- those spans to \index commands and using the \printindex command when replacing
-- the div with id 'index'.
-- For all other formats, it will create a div with class 'index-entry-list'
-- containing the index entries.
-- The entries will be sorted alphabetically.
--
-- By default, the text in the index will be the text of the span.
-- If the span has an 'entry' attribute, that will be used instead.
-- For example, the following will add an entry "idea" to the index:
--   We are talking about a [concept]{.index entry="idea"} here.
-- This filter also supports nested index entries, where the text of the index
-- entry is separated by '!' characters. For example:
--   We are talking about a [concept!idea]{.index} here.
-- This will create an index entry "concept" with a subentry "idea".
--
-- This filter requires the fignos.lua filter to be run before it, as it relies
-- on the fignos.lua filter to process the headers and add the section-number
-- attribute to the headers.

-- local logging = require 'theme/logging/logging'

-- First, a few global variables and function to enable tracking the innermost
-- header a span is in.
-- This is needed to be able to add the section number to the index entries.
span_id2innermost_header = {}
last_header_seen = nil
function record_headers(header)
  --logging.warning('record_headers: ', header);
  last_header_seen = header
end

function record_innermost_header_for_span(span)
  assert(span.identifier, 'span should have an id');
  assert(last_header_seen, 'last_header_seen should not be nil');
  --logging.warning('recording last_header_seen for ', span);
  span_id2innermost_header[span.identifier] = last_header_seen
end

-----

used_ids2el = {}
-- create a unique id based on a base string, where the base string is
-- assumed not to be used by the user or any other script yet.
function create_unique_id_for_el(base, el)
  local counter = 1
  local id = base .. '_' .. counter
  while used_ids2el[id] do
    id = base .. '_' .. counter
    counter = counter + 1
  end
  used_ids2el[id] = el
  return id
end

-----

local function is_index_span(el)
  -- Check if the span has class "index"
  return el.classes:includes('index')
end

local function ensure_every_index_span_has_an_id(el)
    if not is_index_span(el) then
        return el
    end
    -- If the span does not have an identifier, create a unique one
    if not el.identifier or el.identifier == '' then
        el.identifier = create_unique_id_for_el('__index_entry', el)
    end
    return el
end

local function escape_latex(s)
  -- Order matters: backslash first so we don't re-escape what we add.
  s = s:gsub("\\", "\\textbackslash{}")
  -- Characters LaTeX treats specially: # $ % & _ { }
  s = s:gsub("([#%%$&_{}])", "\\%1")
  -- Tilde and caret don't take a simple backslash escape in text mode.
  s = s:gsub("~", "\\textasciitilde{}")
  s = s:gsub("%^", "\\textasciicircum{}")
  return s
end

-- index_entries is a table that maps the id of the span containing the index
-- entry to the list of spans the index entry should refer to.
-- It has 3 fields:
--   . text, the text to be added to the index,
--   . spans, the id's of the pandoc spans that should be referred to from this
--     index entry,
--   . subentries, a table that contains subentries for this index entry.
--   The subentries are also tables with the same structure as index_entries.
index_entries = {}

local function find_index_entries_in_text(span)
  if not is_index_span(span) then
    return span
  end
  --logging.error('Found index entry: ' .. pandoc.utils.stringify(span.content))
  local text = pandoc.utils.stringify(span.content)
  -- if there is an "entry" attribute, use that as the text
  if span.attributes and span.attributes['entry'] then
    text = span.attributes['entry']
  end
    -- split the index entry text on '!' characters, as these are used to indicate
  -- different levels of entry in the index.
  local parts = {}
  for part in string.gmatch(text, "[^!]+") do
    -- remove leading and trailing whitespace from each part
    part = part:match('^%s*(.-)%s*$')
    -- if the part is empty, skip it
    if part == '' then
      goto continue
    end
    --logging.warning('adding part: ', part);
    table.insert(parts, part)
    ::continue::
  end

  local index_entry = index_entries
  for i, part in ipairs(parts) do
    if not index_entry[part] then
      index_entry[part] = { text = part, spans = {}, subentries = {} }
    end
    -- if this is not the last part, we create a new index entry for the subentry
    if i < #parts then
      index_entry = index_entry[part].subentries
    else
      -- this is the last part, we add the span to the index entry
      assert(i == #parts)
      table.insert(index_entry[part].spans, span)
    end
  end

  -- when output latex, just use latex's built-in index command
  if FORMAT:match 'latex' then
    local latex_index_entry = '\\index{'
    for i, part in ipairs(parts) do
      if i > 1 then
        latex_index_entry = latex_index_entry .. '!'
      end
      latex_index_entry = latex_index_entry .. escape_latex(part)
    end
    latex_index_entry = latex_index_entry .. '}'
    return { span,
             pandoc.RawInline('latex', latex_index_entry)}
  end
  return span
end

local function get_index_entry_section_number(span)
  -- Get the section number from the innermost header of the element
  local header = span_id2innermost_header[span.identifier]
  --logging.warning('innermost header: ', header);
  if header and header.attr and header.attr.attributes then
    local section_number = header.attr.attributes['section-number']
    if section_number then
      return section_number
    end
  end
  return nil
end

local function create_index_entry(entry_text, spans, level)
  -- Create a new span for the index entry
  -- We build up that span with "inlines" bit by bit, in variable entry_inlines."
  local entry_inlines = {}
  for i = 1, level do
    table.insert(entry_inlines,
      pandoc.Span(pandoc.Str(""),
                  { class = 'index-entry-indentation' }))
  end
  table.insert(entry_inlines,
    pandoc.Span(entry_text, { class = 'index-entry-text' }))
  -- Add links to the spans
  local entry_links = {}
  for i, span in ipairs(spans) do
    -- Create a link to the span
    local ref_text = get_index_entry_section_number(span)
    if not ref_text then
      ref_text = '(' .. pandoc.utils.stringify(i) .. ')'
    end
    local link = pandoc.Link(ref_text, '#' .. span.identifier)
    if i > 0 then
      table.insert(entry_links, pandoc.Space())
    end
        table.insert(entry_links, link)
    if i < #spans then
      table.insert(entry_links, pandoc.Str(','))
    end
  end
  table.insert(entry_inlines, pandoc.Space())
  table.insert(entry_inlines,
    pandoc.Span(entry_links, { class = 'index-entry-locator' }))
  return pandoc.Span(entry_inlines, { class = 'index-entry' })
end

local function get_sorted_keys(t)
  local keys = {}
  for key in pairs(t) do
    table.insert(keys, key)
  end
  table.sort(keys, function(a, b) return a:lower() < b:lower() end)
  return keys
end

local function create_index_entry_hierarchy(entries, level)
  -- Sort the index entries alphabetically
  local entry_texts = get_sorted_keys(entries)
  -- Create a list of index entries
  local index_list = pandoc.List:new()
  if #entry_texts == 0 then
    -- If there are no entries, return an empty list
    return index_list
  end
  -- When this is the first level, leave a blank line between index entries
  -- starting with a different letter. It makes it easier to read an index
  -- with lots of entries.
  local first_letter_prev_entry = entry_texts[1]:sub(1, 1):lower()
  for _, entry_text in ipairs(entry_texts) do
    local first_letter = entry_text:sub(1, 1):lower()
    if level == 0 and first_letter ~= first_letter_prev_entry then
      index_list:insert(pandoc.Para({pandoc.Str('')}))
      first_letter_prev_entry = first_letter
    end
    local sub_entries = entries[entry_text].subentries
    local spans = entries[entry_text].spans
    --logging.warning('Processing index entry: ', entry_text, ' with spans: ', spans);
    local index_entry_span = create_index_entry(entry_text, spans, level)
    index_list:insert(index_entry_span)
    index_list:extend(create_index_entry_hierarchy(sub_entries, level + 1))
  end
  return index_list
end

local function process_divs(div)
  -- Check if the div has an id of "index"
  if div.identifier ~= 'index' then
    return div
  end
  if FORMAT:match 'latex' then
    return pandoc.RawBlock('latex', '\\printindex')
  end
  return {
    pandoc.Header(1,
      pandoc.Str('Index'),
      { id = 'index-header', class = 'unnumbered' }),
    pandoc.Div(
      create_index_entry_hierarchy(index_entries, 0),
      { class = 'index-entry-list' }),
  }
end

-- We first make sure each index span has an id.
-- Then, we record for each span the innermost header it is in.
-- Then, we process all spans, to find all index entries in the text.
-- Then we need to process all divs, to find the div with name "#index".
return {
  { Span = ensure_every_index_span_has_an_id },
  {
    traverse = 'topdown',
    Header = record_headers,
    Span = record_innermost_header_for_span,
  },
  { Span = find_index_entries_in_text },
  { Div = process_divs } };
