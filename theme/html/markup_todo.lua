-- This lua pandoc filter converts footnotes to HTML "sidenote"s
-- local logging = require 'theme/html/logging'

-- convert \todo's and \missingcontent's to HTML sidenotes
-- They can appear as both RawBlock or RawInlines.

todo_counter = 0;

function get_next_todo_class_id()
  todo_counter = todo_counter + 1;
  note_id = "todo_" .. todo_counter;
  sidenote_class = "todo"
  return sidenote_class, note_id;
end

function create_html_spans(sidenote_class, note_id, content, isblock)
  local sidenote_span =
    pandoc.Span(content,
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

-- Also convert Spans with class "todo"
function Span (span)
  -- FIXME: I should check if any class is .todo, not just the first one.
  if not (span.classes[1] == "todo") then
    return span;
  end
  if FORMAT:match 'html' then
    sidenote_class, note_id = get_next_todo_class_id()
    return create_html_spans(sidenote_class, note_id, span.content, false);
  end
  if FORMAT:match 'latex' then
    return {
      pandoc.RawInline('latex', '\\todospan{'),
      span,
      pandoc.RawInline('latex', '}')
    }
  end
end

function Div(div)
  if div.classes[1] == "TODO" then
    inlines = pandoc.utils.blocks_to_inlines(div.content);
    if FORMAT:match 'latex' then
      table.insert(inlines, 1, pandoc.RawInline('latex', '\\tododiv{'));
      table.insert(inlines, pandoc.RawInline('latex', '}'));
      return pandoc.Para(inlines)
    end
    if FORMAT:match 'html' then
      sidenote_class, note_id = get_next_todo_class_id()
      return create_html_spans(sidenote_class, note_id, inlines, true);
    end
  end
end
