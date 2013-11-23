class Application
	include DataMapper::Resource

	belongs_to :customer

	property :id, Serial
	property :name, String, :required => true, :default => "Unknown"
	property :encodedCodeAtAppId, String, :required => true, :default => "Unknown"
	property :platform, String, :required => true
	property :credential, Text, :required => true # if its a GCM cred, it will be the API Key, if APNS, a base-64 encoded p12
	property :credentialPassword, String #optional, only for 

end