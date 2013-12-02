# Represents an ET Customer
class Customer
	include DataMapper::Resource

	has n, :applications, :constraint => :destroy!
	
	property :id, Serial
	property :name, String, :required => true
	property :memberID, String, :required => true, :unique => true
	property :stack, String, :required => true
	property :oauthToken, Text, :required => false


	def stack_url
		if self.stack == 'S1' 
	        fullURL = "http://app.exacttarget.com"
	    else
	    	fullURL = "http://app.#{self.stack.downcase}.exacttarget.com"
	    end
	    return fullURL
	end
end