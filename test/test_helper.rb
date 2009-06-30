
require "test/unit"
require "rubygems"

gem "nayutaya-kagemusha", ">= 0.0.9"
require "kagemusha"

begin
  require "redgreen"
rescue LoadError
  # nop
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
