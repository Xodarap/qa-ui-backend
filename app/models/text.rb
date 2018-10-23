require 'text_parser'

class Text < ApplicationRecord
  belongs_to :parent, class_name: 'Text', optional: true
  has_many :children, class_name: 'Text', foreign_key: 'parent_id'

  def self.build_text(text)
    parsed = TextParser.new.parse(text)
    children = self.materialize(parsed)
    return children[0] if children.count == 1
    CompoundText.new(children: children)
  end


  private
  def self.materialize(parsed)
    parsed.flat_map do |element|
      if element.key?(:simple)
        SimpleText.new(body: element[:simple])
      else
        children = self.materialize(element[:pointer])
        PointerText.new(children: children)
      end
    end
  end
end

class SimpleText < Text
  def display
    body
  end
end

class PointerText < Text
  def display
    recursive = children.map do |child|
      child.display
    end.join('') 
    "[#{recursive}]"
  end
end

class CompoundText < Text
  def display
    recursive = children.map do |child|
      child.display
    end.join('') 
  end
end
