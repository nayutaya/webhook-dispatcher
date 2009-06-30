
require "test/unit"
require "rubygems"

begin
  require "redgreen"
rescue LoadError
  # nop
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
