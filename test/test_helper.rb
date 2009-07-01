
require "test/unit"
require "rubygems"

gem "nayutaya-kagemusha", ">= 0.0.9"
require "kagemusha"

begin
  require "redgreen"
rescue LoadError
  # nop
end

begin
  require "win32console" if /win32/ =~ RUBY_PLATFORM
rescue LoadError
  # nop
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
