# Represents an ET Customer
class Customer
	include DataMapper::Resource

	has n, :applications
	
	property :id, Serial
	property :name, String, :required => true
	property :memberID, String, :required => true, :unique => true
	property :stack, String, :required => true
	property :oauthToken, String, :required => true


end