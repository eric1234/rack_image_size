Bundler.require :default, :development

require 'test/unit'
class ToTempfileTest < Test::Unit::TestCase

  def test_tempfile
    t = Tempfile.new 'test'
    t.write 'Testing'
    t.rewind

    t2 = t.to_tempfile
    assert_kind_of Tempfile, t2
    assert t2.path
    assert_equal 'Testing', t2.read
  end

  def test_stringio
    t = StringIO.new 'Testing'

    t2 = t.to_tempfile
    assert_kind_of Tempfile, t2
    assert t2.path
    assert_equal 'Testing', t2.read
  end

end
