require './init'

puts "Setting up administrator"
admin = User.first(:email => 'admin') || User.new({:email => 'admin'})
admin.password = 'Welcome@1'
admin.password_confirmation = 'Welcome@1'
admin.admin = true
admin.approved = true

if admin.save
	puts "Admin set up."
	exit 0
else
	puts "Admin failed. Sorry."
	exit 1
end

exit 0