require 'bundler/setup'
require 'ruby_code'

puts "Loading Native"
require 'ruby_code/native'
puts "Loaded"

gets

puts "NUMBER: #{RubyCode.number}"
puts "TIME: #{RubyCode.precise_time}"
pus "OK!"
