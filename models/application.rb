class Application
	include DataMapper::Resource

	has n, :versions, :constraint => :destroy!
	has 1, :apiToken

	property :id,		Serial
	property :name, 	String, 	:required => true, :unique => true
	property :description, Text
	property :icon, 	Text, :length => 10485760 # 10 mb

	# Apple Stuff
	property :bundle_identifier, 	String


	def most_recent_android_version
		self.versions.first(:platform => :android, :order => [:id.desc])
	end

	def most_recent_ios_version
		self.versions.first(:platform => :ios, :order => [:id.desc])
	end
end