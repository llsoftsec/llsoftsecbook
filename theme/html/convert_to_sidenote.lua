-- This lua pandoc filter converts footnotes to HTML "sidenote"s
-- local logging = require 'theme/html/logging'

sidenote_counter = 0;

function Note (note)
  -- logging.temp('note', note)
  -- Convert a Pandoc Note AST node into AST nodes resembling:
  --   <span class="sidenote_ref" href="#sidenote_xxx"><sup>ctr</sup></span>
  --   <span id="sidenote_xxx" class="sidenote">ctr. xxx</span>
  sidenote_counter = sidenote_counter + 1;
  note_id = "sidenote_" .. sidenote_counter;
  sidenote_content = {
    pandoc.Str(sidenote_counter ..  ". "),
    -- A Note AST node has a "block" as content. A Span AST node needs an
    -- "Inline" as content.
    table.unpack(pandoc.utils.blocks_to_inlines(note.content))};
  local sidenote_span =
    pandoc.Span(sidenote_content,
                pandoc.Attr(note_id, {"sidenote"}, {}));
  local sidenote_ref = pandoc.Span(
    pandoc.RawInline(
      "html",
      "<sup>" .. sidenote_counter .. "</sup>"),
      pandoc.Attr("", {"sidenote_ref"}, {href = "#" .. note_id}));
  -- logging.temp('span', span)
  return {sidenote_ref, sidenote_span}
end

-- convert \todo's and \missingcontent's to HTML sidenotes
-- They can appear as both RawBlock or RawInlines.

todo_counter = 0;
missingcontent_counter = 0;

function get_raw_text(raw_content)
  -- logging.temp('seeing rawblock/rawinline', raw_content);
  if string.find(raw_content, "^\\todo{") then
    todo_counter = todo_counter + 1;
    note_id = "todo_" .. todo_counter;
    keyword_length = string.len("\\todo{");
    sidenote_class = "todo"
    assert(string.find(raw_content, "}$"),
           "\\todo doesn't end with '}'");
  else if string.find(raw_content, "^\\missingcontent{") then
      missingcontent_counter = missingcontent_counter + 1;
      note_id = "missingcontent_" .. missingcontent_counter;
      keyword_length = string.len("\\missingcontent{");
      sidenote_class = "missingcontent"
      assert(string.find(raw_content, "}$"),
             "\\missingcontent doesn't end with '}'");
    else
      return nil;
    end
  end
  local len = string.len(raw_content);
  -- strip of '\\todo{' and '}'
  local content = string.sub(raw_content, keyword_length+1, len-1);
  -- logging.temp('recognized ' .. sidenote_class .. ': ' .. content);
  return sidenote_class, note_id, content;
end

function create_spans(sidenote_class, note_id, content, isblock)
  local sidenote_span =
    pandoc.Span(pandoc.Str(content),
                pandoc.Attr(note_id, {sidenote_class}, {}));
  local sidenote_ref =
    pandoc.Span(
      pandoc.RawInline("html", "<sup>" .. sidenote_class .. "</sup>"),
      pandoc.Attr("", {sidenote_class .. "_ref"}, {href = "#" .. note_id}));
  if isblock then
    sidenote_span = pandoc.Plain(sidenote_span);
    sidenote_ref = pandoc.Plain(sidenote_ref);
  end
  return {sidenote_ref, sidenote_span}
end


function RawInline (rawinline)
  if not rawinline.format == 'tex' then
    return rawinline;
  end
  sidenote_class, note_id, rawcontent = get_raw_text(rawinline.text);
  if sidenote_class == nil then
    return rawblock;
  end
  return create_spans(sidenote_class, note_id, rawcontent, false);
end

function RawBlock (rawblock)
  -- convert \todo's to HTML sidenotes.
  -- \todo's are present as rawblocks for format tex.
  if not rawblock.format == 'tex' then
    return rawblock;
  end
  sidenote_class, note_id, content = get_raw_text(rawblock.text);
  if sidenote_class == nil then
    return rawblock;
  end
  return create_spans(sidenote_class, note_id, content, true);
end
