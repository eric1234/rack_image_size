# Utility class to help deal with the URI. This is not a generic class
# like Ruby's URI but a special class just for doing what we need
# to do relating to URIs.
class Rack::ImageSize::URI

  def initialize(uri)
    @uri = uri
  end

  # If the URL is just a path (i.e. no protocol, server, port)
  # Then will use the env information (from Rack) to turn it into
  # a full URI.
  def urify!(env)
    return if full_uri?
    request = Rack::Request.new env
    @uri = File.join File.dirname(env['PATH_INFO']), @uri if relative_uri?
    @uri = "#{request.scheme}://#{request.host_with_port}#{@uri}"
  end

  # The URI. Just currently used in testing.
  def to_s
    @uri
  end

  private

  def relative_uri?
    !full_uri? && @uri !~ /^\//
  end

  def full_uri?
    @uri =~ /^\w+\:\/\//
  end

end
