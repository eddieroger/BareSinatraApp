class Application
	include DataMapper::Resource

	belongs_to :customer

	property :id, Serial
	property :name, String, :required => true, :default => ""
	property :encodedCodeAtAppId, String, :required => true, :default => ""
	property :platform, String, :required => true
	property :credential, Text, :required => true # if its a GCM cred, it will be the API Key, if APNS, a base-64 encoded p12
	property :credentialPassword, String #optional, only for 

	validates_with_method :checkApnsCertificate, :if => lambda { |app| app.platform == 'APNS' }

	def apnsCertificate
		return nil unless self.platform == 'APNS'

		return OpenSSL::PKCS12.new(Base64.decode64(self.credential), self.credentialPassword)
	end

	def gcmApiKey
		return nil unless self.platform == 'GCM'

		return credential
	end

	def checkApnsCertificate
		puts "Checking APNS Certificate"

		begin
			p12 = OpenSSL::PKCS12.new(Base64.decode64(self.credential), self.credentialPassword)
        	isProd = p12.certificate.subject.to_s.include?("Apple Production")
        	isDev = p12.certificate.subject.to_s.include?("Apple Development")
        rescue OpenSSL::PKCS12::PKCS12Error => error
        	puts "PKCS12 Error #{error}"
        	return [false, "Error validating certificate: #{error}"]
        rescue StandardError => error
        	return [false, "Error validating certificate: #{error}"]        	
        end


        puts "Is Prod? #{isProd ? 'Yes' : 'No'}" 
        puts "Is Dev? #{isDev ? 'Yes' : 'No'}" 

        if isProd || isDev
        	return true
        else
        	[false, "Certificate couldn't be validated as APNS Prod or Dev"]
        end
		
	end

end