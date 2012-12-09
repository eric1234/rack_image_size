# OpenURI returns a StringIO for small stuff and Tempfile for large
# stuff. But we need a real file no matter what so we can analyze it
# with ImageMagick. So we implement a to_tempfile method on both objects
# (so we can treat them the same) which gives us a real file always.
require 'tempfile'

class Tempfile

  # We are already a tempfile so just return outselves
  def to_tempfile
    self
  end
end

class StringIO

  def to_tempfile
    t = Tempfile.new 'string-io', nil, :encoding => 'ascii-8bit'
    t.write self.read
    t.rewind
    t
  end

end
