-- This lua pandoc filter converts @fig: references.
-- similarly to how https://github.com/tomduck/pandoc-fignos works.
-- pandoc-fignos is no longer maintained, therefore, we re-implement
-- the functionality of it that we depend on in our own filter here.
-- local logging = require 'theme/html/logging'

figure_counter = 0;
label2id = {};

function get_next_figure_counter_and_id(label)
  figure_counter = figure_counter + 1;
  -- figure_id = "figure_" .. figure_counter;
  label2id[label] = {count = figure_counter, pandocid = label};
  return figure_counter, figure_id;
end

function get_figure_count(label)
  return label2id[label].count
end

function is_fig_label(label)
  return label:find("^fig:")
end

-- First find all Figures and give them ids and labels.
-- Also prepend the caption with "Figure x:"
function process_figures (figure)
  local label = figure.identifier;
  -- Only process Figure's who's label starts with "fig:"
  if not is_fig_label(label) then
    return;
  end
  figure_count, figure_id = get_next_figure_counter_and_id(label);
  -- add "Figure x: " to start of caption
  prefix = "Figure "..get_figure_count(label)..": ";
  if #figure.caption.long > 0 and figure.caption.long[1].tag == "Plain" then
    -- Avoid creating more blocks, as that will result in the prefix
    -- being on a line by it's own in the LaTeX/PDF output.
    pandoc.List.insert(figure.caption.long[1].content, 1, prefix);
  else
    pandoc.List.insert(figure.caption.long, 1, prefix);
  end
  return figure;
end

-- convert Cite if the tag starts with @fig: to a link to the
-- corresponding figure.
function process_cites (cite)
  local tag = cite.tag;
  if #cite.citations ~= 1 then
    -- if the number of citations is more than 1, than this is not a reference
    -- to a figure
    return
  end
  local label = cite.citations[1].id;
  if not is_fig_label(label) then
    return;
  end
  if label2id[label] == nil then
    -- label for figure is not found
    io.stderr:write('Reference @'..label..' found, but no figure found with that label\n');
    return
  end
  local figure_pandocid = label2id[label].pandocid;
  return pandoc.Link(pandoc.Str(get_figure_count(label)), '#'..figure_pandocid);
end

-- The below ensures that first all figures are processed, and then all cites
-- are processed.
return {{Figure = process_figures}, {Cite = process_cites}}