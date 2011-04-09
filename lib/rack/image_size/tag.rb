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
  def add_style!(style)
    if has_style?
      append_style style
    else
      install_style style
    end
  end

  # Will return the tag's as a plain string
  def to_s
    @tag
  end

  private

  # Does the tag already have a style attribute
  def has_style?
    @tag =~ /style/
  end

  # Add the given style to the already existing style attribute
  def append_style(style)
    @tag.sub! /(style\s*=\s*\"[^"]+)\"/, %Q{\\1;#{style}"}
  end

  # Add the given style to the tag without a style attribute
  def install_style(style)
    @tag.sub! /(\/?\>)$/, %Q{ style="#{style}"\\1}
  end

end
