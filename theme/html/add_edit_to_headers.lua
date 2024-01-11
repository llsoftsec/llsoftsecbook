-- This script adds an "edit" button after every header that, when clicked,
-- brings the reader to a github interface to edit the source code of the
-- relevant section, and create a pull request.

-- pandoc has poor support for getting source line information. It is
-- currently (as of 2024) only supported if the input is commonmark.
-- In LLSoftSecBook, we use the pandoc dialect of Markdown, not commonmark,
-- so we cannot use that.
-- To get line information, we use the following hack in this script:
-- We first read the book.md source file and store the line number for
-- each header we find. We find headers by parsing against a regular
-- expression (^#+ .*$).
-- Then we iterate over all headers in the pandoc AST and annotate a
-- header with line number information and a link to the github "edit"
-- interface.

-- local logging = require 'theme/html/logging'

local headernr2depth_linenr = {}
function mdheaders_linenrs_in_file(file)
  local linenr = 1
  local header_count = 0
  local header_pattern = "^(#+) +(.*)$"
  for line in io.lines(file) do
    if string.find(line, header_pattern) then
      _, _, header_hashes, header_text = string.find(line, header_pattern)
      depth = string.len(header_hashes)
      headernr2depth_linenr[header_count] = {depth=depth, text=header_text, linenr=linenr};
      header_count = header_count + 1;
    end
    linenr = linenr + 1;
  end
  return headernr2depth_linenr
end

function Pandoc(p)
  mdheaders_linenrs_in_file('book.md')
end

local header_nr=0
function Header (h)
  parsed_header_info = headernr2depth_linenr[header_nr]
  linenr = parsed_header_info.linenr
  if h.level ~= parsed_header_info.depth then
    print("In filter add_edit_to_headers.lua:")
    print("Expected a header at level "..parsed_header_info.depth,
          " at source linenr "..parsed_header_info.linenr,
          ": "..parsed_header_info.text);
    print("  instead saw ",h);
    os.exit(-1);
  end
  header_nr = header_nr + 1
  link_url = "https://github.com/llsoftsec/llsoftsecbook/edit/main/book.md#L"..linenr;
  local edit_link = pandoc.Link({pandoc.Str ''}, link_url, "Suggest an edit",
                                {});
  edit_link.classes = {"suggestedit"}

  h.content = h.content .. {edit_link}
  return h
end



return {
  { Pandoc = Pandoc },
  { Header = Header }
}