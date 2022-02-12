function Header (h)
  -- if AST object is header type, it is passed through this function

  -- create link AST node and assign to 'selflink' class for CSS handle
  local self = pandoc.Link({pandoc.Str '§'}, '#' .. h.identifier)
  self.classes = {'selflink'}

  -- update the content
  h.content = h.content .. {pandoc.Space(), self}
  return h
end
