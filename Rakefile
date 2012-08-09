begin
  require 'cane/rake_task'
rescue LoadError
  warn "cane not available, please install development requirements"
  exit 1
end

VERSION = IO.read('VERSION').chomp

desc "Clean out old gems"
task :clean do
  gems = Dir.glob("ruby-skype-#{VERSION}-*.gem")
  rm gems if not gems.empty?
end

desc "Check code quality"
Cane::RakeTask.new(:quality) do |cane|
  cane.exclusions_file = '.cane-exclusions.yaml'
  #cane.style_measure = 120
  cane.no_doc = true
end

desc "Build gems for all platforms"
task :gem => [:clean, :quality] do
  %w{mswin32 mingw32 cygwin linux}.each do |platform|
    ENV['GEM_PLATFORM'] = platform
    sh 'gem', 'build', 'ruby-skype.gemspec'
  end
end
