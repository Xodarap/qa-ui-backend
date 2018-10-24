require 'text_parser'

class Text < ApplicationRecord
  attr_accessor :counter
  belongs_to :parent, class_name: 'Text', optional: true
  has_many :children, class_name: 'Text', foreign_key: 'parent_id'

  def self.build_text(text)
    parsed = TextParser.new.parse(text)
    children = self.materialize(parsed)
    return children[0] if children.count == 1
    CompoundText.new(children: children)
  end

  def as_json
    {
      display_expanded: display(true),
      display_collapsed: display(false),
      expanded: expanded,
      body: body,
      children: children.map(&:as_json),
      id: id,
      type: type
    }
  end

  def find_pointer(number)
    return self if counter == number
    children.map{|child| child.find_pointer(number)}.compact.first
  end

  def destroy_cascade
    children.each(&:destroy_cascade)
    destroy
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
  def display(expand = true)
    body
  end

  def assign_counters(start = 1)
    start
  end
end

class PointerText < Text
  def display(expand = true)
    return "##{counter}" unless expand || expanded?

    recursive = children.map do |child|
      child.display(expand)
    end.join('') 
    "[#{recursive}]"
  end

  def assign_counters(start = 1)
    if expanded?
      children.reduce(start) do |count, child|
        child.assign_counters(count)
      end
    else
      @counter = start
      start+1
    end
  end
end

class CompoundText < Text
  def display(expand = true)
    recursive = children.map do |child|
      child.display(expand)
    end.join('') 
  end

  def assign_counters(start = 1)
    children.reduce(start) do |count, child|
      child.assign_counters(count)
    end
  end
end
