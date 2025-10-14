-- SPDX-FileCopyrightText: <text>Copyright 2024,2025 Arm Limited and/or its
-- affiliates <open-source-office@arm.com></text>
-- SPDX-License-Identifier: MIT

-- This lua pandoc filter converts @fig: references.
-- similarly to how https://github.com/tomduck/pandoc-fignos works.
-- pandoc-fignos is no longer maintained, therefore, we re-implement
-- the functionality of it that we depend on in our own filter here.
-- Additionally, this filter also converts references to examples,
-- definitions and section headers.

-- This filter follows roughly the following processing steps:
-- 1. Figures are first-class objects in pandoc. Examples and definitions
--    are divs with classes "example" and "definition".
--    Their captions are stored in the "caption" attribute on the div.
-- 2. The filter iterates through each figure, example, definition and section
--    header and assigns a number (or hierarchical number, e.g. "2.1.3.5" for
--    section headers) to each of them, and stores the number in the "count"
--    attribute on the object.
-- 3. - For figures, it adds "Figure x: " to the caption, with x being the
--      number assigned in the previous step.
--    - For examples and definitions, it adds "Example x: " or "Definition x: ",
--      and also adds what is in the "caption" attribute at the start of the
--      content of the div."
-- 4. References to figures, examples, definitions and section headers are
--    replaced with links to them. References are recognized by the prefix
--    in the citation. A reference starting with "@fig:" is assumed to
--    refer to a figure, "@ex:" to an example, "@def:" to a definition,
--    and "@sec:" to a section header.
--  5. For examples and definitions, for the latex output, instead of a
--     pandoc link (which probably wouldn't work, as pandoc doesn't support
--     linking to divs), a raw latex link is inserted, which uses the
--     \hyperref command to link to the div. These divs are converted to
--     environments in the LaTeX output, so the \hyperref command works.

-- local logging = require 'theme/logging/logging'

counters = {
  ['figure'] = 0,
  ['definition'] = 0,
  ['example'] = 0
}

-- maps a citeref to the lua pandoc object that is refered to.
citeref2referee = {}

function compute_counter(kind, referee)
  citeref = referee.identifier;
  count = counters[kind] + 1;
  counters[kind] = count;
  -- logging.error('compute_counter: kind = ', kind, ', count = ', count, ', citeref = ', citeref);
  citeref2referee[citeref] = referee;
  -- store the count in the "count" attribute value
  referee.attributes['count'] = count;
end

function get_reader_label(kind, referee)
  -- for the label, upper case the first letter, e.g. "Example 1"
  -- and append the count, e.g. "Example 1"
  return kind:gsub("^%l", string.upper) .. " " .. referee.attributes['count'];
end

function is_fig_label(label)
  return label:find("^fig:")
end

function is_sec_label(label)
  return label:find("^sec:")
end

function is_example_label(label)
  return label:find("^ex:")
end

function is_def_label(label)
  return label:find("^def:")
end

function citeref2kind(citeref)
  if is_fig_label(citeref) then
    return "figure";
  elseif is_example_label(citeref) then
    return "example";
  elseif is_def_label(citeref) then
    return "definition";
  elseif is_sec_label(citeref) then
    return "section";
  else
    logging.error('citeref2kind: unknown citeref: ', citeref);
    return nil;
  end
end


-- First find all Figures and compute the counter value.
-- Also prepend the caption with "Figure x:"
function process_figures (figure)
  local label = figure.identifier;
  -- Only process Figure's who's label starts with "fig:"
  if not is_fig_label(label) then
    return;
  end
  compute_counter("figure", figure)
  -- add "Figure x: " to start of caption
  label = get_reader_label("figure", figure);
  prefix = label..": ";
  if #figure.caption.long > 0 and figure.caption.long[1].tag == "Plain" then
    -- Avoid creating more blocks, as that will result in the prefix
    -- being on a line by it's own in the LaTeX/PDF output.
    pandoc.List.insert(figure.caption.long[1].content, 1, prefix);
  else
    pandoc.List.insert(figure.caption.long, 1, prefix);
  end
  return figure;
end

-- First find all Examples and Definitions and give them ids and labels.
-- Also prepend the caption with "Example/Definition x:"
function process_divs (div)
  -- handle Definitions and Examples
  if div.classes[1] == "definition" or div.classes[1] == "example" then
    kind = div.classes[1]
    compute_counter(kind, div)
    if FORMAT:match 'latex' then
      -- For LaTeX, wrap content in a definition/example environment
      table.insert(div.content, 1, pandoc.RawBlock('latex', '\\begin{' .. kind .. '}\n'));
      if div.attributes['caption'] then
        table.insert(div.content, 2, pandoc.RawBlock('latex', '\\textup{' .. div.attributes['caption'] .. '.}\n'));
      end
      if div.identifier then
        table.insert(div.content, 2, pandoc.RawBlock('latex', '\\label{' .. div.identifier .. '}\n'));
      end
      table.insert(div.content, pandoc.RawBlock('latex', '\\end{' .. kind .. '}\n'));
      return div
    elseif FORMAT:match 'html' then
      label = get_reader_label(kind, div);
      table.insert(div.content, 1, pandoc.Plain(label));
      if div.attributes['caption'] then
        table.insert(div.content, 2, pandoc.Span(div.attributes['caption'], {class = 'caption'}));
      end
      return div;
    end
  end
end

headerlevel2counter = {0,0,0,0,0,0,0,0,0,0};
headerlabel2counter = {};

function header_has_sec_label (header)
  if header.attr and header.attr.identifier and
      is_sec_label(header.attr.identifier)
  then
      return header.attr.identifier
  end
end

-- update_and_get_header_numbers updates the headerlevel2counter
-- values which track the current number for all section levels.
-- It also returns an array of numbers representing the header
-- number for this header.
-- For example, for a section header which should have number
-- "3.2.4. ", this will return [3, 2, 4].
-- This function should be called once for each header, in the
-- order the header appears in the document.
function update_and_get_header_numbers(level)
  id = {}
  for i = 1, level-1 do
    id[i] = headerlevel2counter[i];
  end
  headerlevel2counter[level] = headerlevel2counter[level]+1;
  id[level] = headerlevel2counter[level];
  for i = level+1, #headerlevel2counter do
    headerlevel2counter[i] = 0;
  end
  return id;
end

function process_headers (header)
  local counter = update_and_get_header_numbers(header.level);
  local sec_label = header_has_sec_label(header);
  if sec_label then
    headerlabel2counter[sec_label] = counter;
  end
  -- also add attribute to header containing the section number
  -- so that later pandoc filters can use it.
  header.attr.attributes['section-number'] = section_counter_to_string(counter);
  return header;
end

function section_counter_to_string(section_number_array)
  local ref_text = '';
  for i = 1, #section_number_array do
    ref_text = ref_text..section_number_array[i];
    if i ~= #section_number_array then
      ref_text = ref_text..'.'
    end
  end
  return ref_text;
end

function get_section_reference_text(label)
  local section_number_array = headerlabel2counter[label]
  return section_counter_to_string(section_number_array);
end

function get_link_text(citation, label)
  -- the link text contains of "prefix" (if any) + label + "suffix" (if any)
  -- see https://pandoc.org/MANUAL.html#citation-syntax
  -- For now, this function only supports prefixes. If support for
  -- suffixes would be needed, it will have to be implementd in this function.
  local text = pandoc.List:new();
  for i = 1, #citation.prefix do
    pandoc.List.insert(text, citation.prefix[i])
  end
  if #citation.prefix > 0 then
    pandoc.List.insert(text, pandoc.Space());
  end
  pandoc.List.insert(text, pandoc.Str(label));
  return text;
end

function ref_not_found (label, kind_str)
  io.stderr:write('Reference @'..label..' found, but no ' .. kind_str .. ' found with that label\n');
  return
end

function process_cite (cite, citeref, kind)
  if citeref2referee[citeref] == nil then
    ref_not_found(citeref, kind);
    return
  end
  local referee = citeref2referee[citeref];
  local count = referee.attributes['count'];
  local link_text = get_link_text(cite.citations[1], count);
  -- if latex and def or example, then insert raw latex:
  -- \hyperref[sec:hello]{this section}.
  if FORMAT:match 'latex' and (kind == "definition" or kind == "example") then
    local link_text = pandoc.utils.stringify(link_text);
    return pandoc.RawInline('latex', '\\hyperref['..referee.identifier..']{'..link_text..'}');
  end
  local link = pandoc.Link(link_text, '#'..referee.identifier);
  return link;
end

function process_sec_cite (cite, label)
  if headerlabel2counter[label] == nil then
    ref_not_found(label, "section");
    return
  end
  local link_text = get_link_text(cite.citations[1],
                                  get_section_reference_text(label));
  local link = pandoc.Link(link_text, '#'..label);
  return link;
end

-- convert Cite if the tag starts with @fig:, @sec:, @ex: or @def: to a link to the
-- corresponding figure/section/example/definition.
function process_cites (cite)
  local tag = cite.tag;
  if #cite.citations ~= 1 then
    -- if the number of citations is more than 1, than this is not a reference
    -- to a figure
    return
  end
  -- a "citeref" has a form such as "fig:1", "sec:2.3", "ex:4" or "def:5"
  local citeref = cite.citations[1].id;
  if is_fig_label(citeref) or is_example_label(citeref) or
    is_def_label(citeref)
  then
    kind = citeref2kind(citeref);
    return process_cite(cite, citeref, kind);
  end
  if is_sec_label(citeref) then
    return process_sec_cite(cite, citeref);
  end
end

-- The below ensures that first all figures, headers and divs are processed,
-- and then all cites are processed.
return {{Header=process_headers}, {Figure = process_figures},
        {Div = process_divs}, {Cite = process_cites}}