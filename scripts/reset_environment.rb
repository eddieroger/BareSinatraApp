# Reset Environment
require './init'

puts "Cleaning up versions..."
Version.all.destroy

puts "Cleaning up apps..."
Application.all.destroy

puts "Done."