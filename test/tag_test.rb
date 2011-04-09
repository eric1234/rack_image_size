Bundler.require :default, :development

require 'test/unit'
class TagTest < Test::Unit::TestCase

  def setup
    @tag = Rack::ImageSize::Tag.new %q{<img src="foo.gif" alt="Bar">}
  end

  def test_to_s
    assert_equal %q{<img src="foo.gif" alt="Bar">}, @tag.to_s
  end

  def test_accessor
    assert_equal 'foo.gif', @tag['src']
    assert_equal 'Bar', @tag['alt']
  end

  def test_style
    @tag.add_style! "width: 230px"
    assert_equal %q{<img src="foo.gif" alt="Bar" style="width: 230px">}, @tag.to_s
    @tag.add_style! "height: 150px"
    assert_equal %q{<img src="foo.gif" alt="Bar" style="width: 230px;height: 150px">}, @tag.to_s
  end

end
