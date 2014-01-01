Bundler.require :default, :development

require 'rack/builder'
require 'rack/mock'

require 'test/unit'
class MiddlewareTest < Test::Unit::TestCase

  def test_call
    app = Rack::Builder.new do
      use Rack::ImageSize
      run proc {|env| [200, {'Content-Type' => 'text/html'}, [%q{
<img src="logo_sm.gif">
<img src="/images/icons/adwords-24.gif">
<img src="http://www.google.com/images/logos/ps_logo.png">
      }]]}
    end.to_app
    mock = Rack::MockRequest.new app
    assert_equal %q{
<img src="logo_sm.gif" width="150" height="55">
<img src="/images/icons/adwords-24.gif" width="24" height="24">
<img src="http://www.google.com/images/logos/ps_logo.png" width="411" height="142">
    }.strip, mock.get('http://www.google.com/images/errors/index.html').body.strip    
  end

end
