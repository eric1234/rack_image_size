Bundler.require :default, :development

require 'test/unit'
class TagTest < Test::Unit::TestCase

  def setup
    @tag = Rack::ImageSize::Tag.new %q{<img src="foo.gif" alt="Bar">}
  end

  def test_to_s
    assert_equal %q{<img src="foo.gif" alt="Bar">}, @tag.to_s
  end

  def test_attribute_reader
    assert_equal 'foo.gif', @tag['src']
    assert_equal 'Bar', @tag['alt']
  end

  def test_attribute_writer
    @tag['alt'] = 'Baz'
    assert_equal %q{<img src="foo.gif" alt="Baz">}, @tag.to_s
    @tag['title'] = 'Boo'
    assert_equal %q{<img src="foo.gif" alt="Baz" title="Boo">}, @tag.to_s
  end

end
