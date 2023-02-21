-- This lua pandoc filter converts issue spans into nice-looking
-- links to github issues
-- local logging = require 'theme/html/logging'

function Meta (meta)
  -- store url of the github repo in global variable github_repo
  github_repo = pandoc.utils.stringify(meta["github-repo"]);
end

function isInteger(s)
  return string.find(s, "^%d+$") == 1;
end

function Span (span)
  -- FIXME: I should check if any class is .issue, not just the first one.
  if not (span.classes[1] == "issue") then
    return span;
  end
  local issue_id = pandoc.utils.stringify(span.content);
  assert (isInteger(issue_id), "issue_id '" .. issue_id .. "' is not an integer.");
  local url = github_repo .. '/issues/' .. issue_id;
  return pandoc.Link('#'..issue_id, url);
end

-- Run the meta filter first to extract the value for "github_repo"
return {
  { Meta = Meta },  -- (1)
  { Span = Span }   -- (2)
}
