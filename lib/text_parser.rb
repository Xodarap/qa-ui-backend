class TextParser < Parslet::Parser
  rule(:simple) { match('[a-zA-Z 0-9?]').repeat(1).as(:simple) }
  rule(:pointer) { match('\\[') >> either.as(:pointer) >> match('\\]')}
  rule(:either) { (simple | pointer).repeat(1) }
  root :either
end
