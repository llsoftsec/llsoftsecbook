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
