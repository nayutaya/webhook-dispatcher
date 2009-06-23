
require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = Dir.glob("test/*_test.rb")
  test.verbose    =  true
end

task :gemspec do
  require "erb"
  require "lib/webhook-dispatcher/version"

  src = File.open("webhook-dispatcher.gemspec.erb", "rb") { |file| file.read }
  erb = ERB.new(src, nil, "-")

  version = WebHookDispatcher::VERSION
  date    = Time.now.strftime("%Y-%m-%d")

  files      = Dir.glob("**/*").select { |s| File.file?(s) }
  test_files = Dir.glob("test/**").select { |s| File.file?(s) }

  File.open("webhook-dispatcher.gemspec", "wb") { |file|
    file.write(erb.result(binding))
  }
end
