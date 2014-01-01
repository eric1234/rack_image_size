Gem::Specification.new do |s|

  s.name        = "rack_image_size"
  s.version     = '0.1.0'
  s.authors     = ['Eric Anderson']
  s.email       = ['eric@pixelwareinc.com']

  s.add_dependency 'rack'
  s.add_dependency 'rack_replace'
  s.add_development_dependency 'rake'

  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'

  s.summary     = 'Adds image dimensions automatically to IMG tags'
  s.description = <<DESCRIPTION
Will automatically add image dimensions to any IMG tags in your response
if they do not already have them. This results in faster rendering on
the client side without any extra work on your part.
DESCRIPTION

end
