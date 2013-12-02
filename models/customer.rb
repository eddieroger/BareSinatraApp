# Represents an ET Customer
class Customer
	include DataMapper::Resource

	has n, :applications, :constraint => :destroy!
	
	property :id, Serial
	property :name, String, :required => true
	property :memberID, String, :required => true, :unique => true
	property :stack, String, :required => true
	property :oauthToken, Text, :required => false


end