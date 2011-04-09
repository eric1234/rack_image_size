Bundler.require :default, :development

require 'test/unit'
class ImageTagTest < Test::Unit::TestCase

  def test_has_dimensions?
    without = Rack::ImageSize::ImageTag.new '<img src="logo.png">'
    assert !without.has_dimensions?

    width = Rack::ImageSize::ImageTag.new '<img src="logo.png" width="200">'
    assert width.has_dimensions?

    height = Rack::ImageSize::ImageTag.new '<img src="logo.png" height="200">'
    assert height.has_dimensions?

    style_width = Rack::ImageSize::ImageTag.new '<img src="logo.png" style="width: 200px">'
    assert style_width.has_dimensions?

    style_height = Rack::ImageSize::ImageTag.new '<img src="logo.png" style="height: 200px">'
    assert style_height.has_dimensions?

    both = Rack::ImageSize::ImageTag.new '<img src="logo.png" width="200" height="200">'
    assert both.has_dimensions?

    style_both = Rack::ImageSize::ImageTag.new '<img src="logo.png" style="width: 200px; height: 200px">'
    assert style_both.has_dimensions?
  end

  def test_dimensions
    google = Rack::ImageSize::ImageTag.new '<img src="http://www.google.com/images/logos/logo.png">'
    assert_equal [103, 40], google.dimensions
    assert_equal [411, 142], google.dimensions('http://www.google.com/images/logos/ps_logo.png')
    assert_equal [411, 142], Rack::ImageSize::ImageTag::CACHE['http://www.google.com/images/logos/ps_logo.png']
    Rack::ImageSize::ImageTag::CACHE['http://www.google.com/images/logos/ps_logo.png'] = [200, 200]
    assert_equal [200, 200], google.dimensions('http://www.google.com/images/logos/ps_logo.png')
    Rack::ImageSize::ImageTag::CACHE.clear
  end

end
