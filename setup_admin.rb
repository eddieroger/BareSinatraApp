require 'rubygems'
require_relative './init'

puts "Setting up administrator"
admin = User.first(:email => 'admin') || User.new({:email => 'admin'})
admin.password = 'Welcome@1'
admin.password_confirmation = 'Welcome@1'
admin.admin = true
admin.approved = true

if admin.save
	puts "Admin set up."
else
	puts "Admin failed. Sorry."
	exit 1
end

puts "Setting up shared user"
user = User.first(:email => 'exacttarget') || User.new({:email => 'exacttarget'})
user.password = 'Mobile@1'
user.password_confirmation = 'Mobile@1'
user.approved = true

if user.save
	puts "User set up."
else
	puts "User failed. Sorry."
	exit 1
end

puts "All done."`
exit 0