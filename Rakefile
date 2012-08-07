
VERSION = IO.read('VERSION').chomp

desc "Clean out old gems"
task :clean do
  gems = Dir.glob("ruby-skype-#{VERSION}-*.gem")
  rm gems if not gems.empty?
end

desc "Build gems for all platforms"
task :gem => :clean do
  %w{mswin32 mingw32 cygwin linux}.each do |platform|
    ENV['GEM_PLATFORM'] = platform
    sh 'gem', 'build', 'ruby-skype.gemspec'
  end
end
