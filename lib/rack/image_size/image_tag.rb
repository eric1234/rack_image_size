require 'rack/image_size/tag'
require 'open-uri'
require 'timeout'

class Rack::ImageSize::ImageTag < Rack::ImageSize::Tag
  CACHE = {}

  # Does the image already have dimensions?
  def has_dimensions?
    @tag =~ /width/ || @tag =~ /height/
  end

  # Will return the dimensions of this images. Will use the src unless
  # uri is passed in (useful for when the URI is not a full URI)
  def dimensions(uri=self['src'])
    cached uri do
      begin
        Timeout::timeout(Rack::ImageSize::TIMEOUT) do
          open(uri.to_s) do |image|
            # QUESTION: Should we sanitize this? If the path comes from
            # user input then it could open an exploit. But that is not
            # the common case. So perhaps the site should just do width
            # and height itself if the image comes from user input.
            specs = `#{Rack::ImageSize::IDENTIFY_COMMAND} #{image.to_tempfile.path}`
            specs.split(/\s+/, 4)[2].split('x').collect(&:to_i) if $? == 0
          end
        end
      rescue Timeout::Error
        $stderr.puts "Failure to load #{uri}"
        nil
      end
    end
  end

  private

  def cached(key)
    key = key.to_s
    if CACHE.has_key? key
      CACHE[key]
    else
      CACHE[key] = yield
    end
  end

end
