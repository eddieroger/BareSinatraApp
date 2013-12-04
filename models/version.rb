class Version
	include DataMapper::Resource

	belongs_to :application

	property :id,			Serial
	property :platform, 	Enum[:unknown, :ios, :android], :default => :unknown

	# Apple Stuff
	property :bundle_identifier, 	String, :length => 200
	property :bundle_version, 		String, :length => 10
	property :encoded_ipa,			Binary, :length => 10485760 # 10mb
	property :ipa_filename,			String, :length => 200

	validates_presence_of :bundle_identifier, :if =>  lambda { |app| app.platform == :ios }
	validates_presence_of :bundle_version, :if =>  lambda { |app| app.platform == :ios }
	validates_presence_of :encoded_ipa, :if => lambda { |app| app.platform == :ios }
	validates_presence_of :ipa_filename, :if => lambda { |app| app.platform == :ios }

	# Android Stuff
	property :encoded_apk, 			Binary, :length => 10485760 # 10mb
	property :apk_filename,			String, :length => 200

	validates_presence_of :encoded_apk, :if => lambda { |app| app.platform == :android }
	validates_presence_of :apk_filename, :if => lambda { |app| app.platform == :android }
end