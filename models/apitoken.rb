class ApiToken < ActiveRecord::Base

	belongs_to :user


	def self.authenticate(accessToken)
		token = ApiToken.where(token: accessToken, active: true).first
		if token
			return token.user
		else
			return false
		end
		# if ApiToken.first(:token => accessToken)
		# 	return true
		# else
		# 	return false
		# end
	end

	def self.get_new_token(length)
		SecureRandom.urlsafe_base64(length)
	end

end

# class ApiToken
# 	include DataMapper::Resource

# 	belongs_to :user

# 	property :id,		Serial
# 	property :token, 	String, 	:required => true, :unique => true

# 	def self.authenticate(accessToken)
# 		puts "ApiToken#authenticate!"
# 		if first(:token => accessToken)
# 			return true
# 		else
# 			return false
# 		end
# 	end

# 	def self.get_new_token
# 		SecureRandom.uuid
# 	end
# end
