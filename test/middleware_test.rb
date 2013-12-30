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
<img src="logo_sm.gif" style="width:150px;height:55px">
<img src="/images/icons/adwords-24.gif" style="width:24px;height:24px">
<img src="http://www.google.com/images/logos/ps_logo.png" style="width:411px;height:142px">
    }.strip, mock.get('http://www.google.com/images/errors/index.html').body.strip    
  end

end
