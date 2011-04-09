Bundler.require :default, :development

require 'test/unit'
class UriTest < Test::Unit::TestCase

  def test_full_uri
    uri = Rack::ImageSize::URI.new 'http://demo.com/foo.gif'
    uri.urify! env
    assert_equal 'http://demo.com/foo.gif', uri.to_s
  end

  def test_path
    uri = Rack::ImageSize::URI.new '/bar.gif'
    uri.urify! env
    assert_equal 'http://example.com:80/bar.gif', uri.to_s
  end

  def test_relative_path
    uri = Rack::ImageSize::URI.new '../baz.gif'
    uri.urify! env
    assert_equal 'http://example.com:80/foo/bar/../baz.gif', uri.to_s
  end

  private

  def env
    {
      'rack.url_scheme' => 'http',
      'SERVER_NAME'     => 'example.com',
      'SERVER_PORT'     => 80,
      'PATH_INFO'       => '/foo/bar/index.html',
    }
  end

end
