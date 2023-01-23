-- This lua pandoc filter converts footnotes to HTML "sidenote"s
-- local logging = require 'theme/html/logging'

function Note (note)
  -- logging.temp('note', note)
  -- Convert an Pandoc Node AST note to a <span class="sidenote"></span>
  -- AST note.
  -- A Note AST node has a "block" as content. A Span AST node needs an
  -- "Inline" as content.
  local span = pandoc.Span(pandoc.utils.blocks_to_inlines(note.content))
  span.classes = {'sidenote'}
  -- logging.temp('span', span)
  return span
end
