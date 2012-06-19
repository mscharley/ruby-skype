
desc "Clean out old gems"
task :clean do
  rm_rf 'ruby-skype-*.gem'
end

desc "Build gems for all platforms"
task :gem => :clean do
  %w{mswin32 mingw32 cygwin linux}.each do |platform|
    ENV['GEM_PLATFORM'] = platform
    sh 'gem', 'build', 'ruby-skype.gemspec'
  end
end
