# Utility class to help deal with modifying a HTML tag using
# some regular expressions. Using something like Nokogiri would be
# overkill.
class Rack::ImageSize::Tag

  def initialize(tag)
    @tag = tag
  end

  # Will return the value of the given attribute
  def [](attribute)
    @tag.scan(/#{attribute}\s*=\s*\"([^"]+)\"/)[0][0] rescue nil
  end

  # Will add the given style to the style tag. Will work regardless if
  # the style attribute already exists.
  def []=(attribute, value)
    @tag.sub!(
      / #{Regexp.escape attribute}\=((['"])[^\2]*\2)/,
      %Q! #{attribute}=\\2#{value}\\2!
    ) ||
    @tag.sub!(/(\/?\>)$/, %Q{ #{attribute}="#{value}"\\1})
  end

  # Will return the tag's as a plain string
  def to_s
    @tag
  end

end
