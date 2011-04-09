require 'rack_replace'

module Rack

  # Will find all images on the response and add the appropriate width
  # and height information if it is not already specified as a HTML
  # attribute or a CSS style.
  #
  # This results in faster rendering on the user's computer as the
  # system does not have to re-layout the page once the image is
  # received. It can layout the page right the first time since it knows
  # the size ahead of time.
  #
  # If size is already specified then the tag is not modified.
  #
  # The width and height information is cached in memory (no fancy
  # sharing between servers with memcache or anything). There is no way
  # to clear the cache other than restarting the application server. It
  # does cache based on the entire URI so if you are using a caching
  # busting technique (like appending a timestamp to the querystring)
  # then you can avoid the cache.
  #
  # To determine the width and height the "identify" command from
  # ImageMagick is used. This should be in your path. The image is
  # download via URI instead of looking on the local filesystem. This
  # allows the asset to be on anywhere (even remote server). Since this
  # values are cached this means only the first request is slow.
  #
  # If your setup would result in lots of cache misses (i.e. many
  # servers, millions of images, etc.) then this implementation is not
  # for you. This is for a simple setup where you have a couple dozen
  # images that once cached will give you constant cache hits and not
  # very much memory usage.
  #
  # True HTML parsing is not done. So if you name your file something
  # like "my-width.png" then it will think the tag already has attributes
  # and move on.
  class ImageSize < Rack::Replace
    # The path "ImageMagick"'s identify command.
    # You can do a replace to set to something different
    IDENTIFY_COMMAND = `which identify`.chop

    # Standard middleware interface:
    #
    #     use Rack::ImageSize
    def initialize(app)
      super app, /\<\s*img[^>]*\>/ do |env, image|
        image = ImageTag.new image
        uri = URI.new image['src']
        if !image.has_dimensions? && uri
          uri.urify! env
          width, height = *image.dimensions(uri)
          image.add_style! "width:#{width}px;height:#{height}px"
        else
          image
        end
      end
    end

  end
end

require 'rack/image_size/image_tag'
require 'rack/image_size/uri'
require 'rack/image_size/to_tempfile'
