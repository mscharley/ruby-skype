begin
  require 'cane/rake_task'
rescue LoadError
  warn "cane not available, please install development requirements"
  exit 1
end

VERSION = IO.read('VERSION').chomp

desc "Clean out old gems"
task :clean do
  gems = Dir.glob("ruby-skype-*.gem")
  rm gems if not gems.empty?
end

desc "Check code quality"
Cane::RakeTask.new(:quality) do |cane|
  cane.exclusions_file = '.cane-exclusions.yaml'
  #cane.style_measure = 120
  cane.no_doc = true
end

desc "Generate documentation with reports"
task :doc do
  sh 'yard', '--no-stats'
  sh 'yard', 'stats', '--list-undoc'
end

desc "Build gems for all platforms"
task :gem => [:clean, :quality] do
  sh 'gem', 'build', 'ruby-skype.gemspec'
end

desc "Publish gems to the world via rubygems.org"
task :publish => [:gem] do
  sh 'gem', 'push', "ruby-skype-#{VERSION}.gem"
end
