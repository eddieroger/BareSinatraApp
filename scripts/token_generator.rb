require 'rubygems'
require_relative '../init'

apps = Application.all

apps.each do |app|
	puts "Examining app #{app.name}"
	if app.apiToken.nil?
		puts "App needs a token. Generating."
		token = ApiToken.new
		token.application = app
		token.token = SecureRandom.uuid
		if token.save
			puts "Saved."
		else
			puts "Error"
		end
	else
		puts "App has a token. Moving on."
	end

end

puts "Done."
