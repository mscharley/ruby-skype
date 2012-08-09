
spec = Gem::Specification.new do |s|
  s.name = 'ruby-skype'
  s.version = IO.read('VERSION').chomp
  s.author = 'Matthew Scharley'
  s.email = 'matt.scharley@gmail.com'
  s.summary = 'Ruby binding to the Skype Public API.'
  s.homepage = 'https://github.com/mscharley/ruby-skype'
  s.license = 'MIT'
  s.description = <<-EOF
    ruby-skype is a binding to the Skype Public API. The Public API is a method to talk
    to the official Skype client running on the local computer and allows for automation
    of the client.
  EOF

  s.required_ruby_version = '~> 1.9'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'

  s.platform = ENV['GEM_PLATFORM']
  case ENV['GEM_PLATFORM']
    when 'mswin32', 'mingw32', 'cygwin'
      s.add_dependency 'ffi'
    when 'linux'
      s.add_dependency 'ruby-dbus', '= 0.7.2'
    else
      puts "Invalid $GEM_PLATFORM value."
      exit 1
  end

  s.files = Dir['{bin,lib}/**/*', 'VERSION', 'README.md', 'LICENSE', 'examples/*'].to_a
end
