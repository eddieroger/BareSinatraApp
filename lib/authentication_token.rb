
	class AuthenticationTokens	
		include Singleton

		attr_reader :redis

		FIVE_MINUTES = 60 * 5 
		ANDROID_TIMEOUT = 60 * 60 * 48 	# 48 Hours
		IOS_TIMEOUT 	= 60 * 2 		# 2 Minutes

		def initialize
			redis_uri = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379'
			uri = URI.parse(redis_uri)
			@redis  ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
		end

		def AuthenticationTokens.finalize(id)
	    	@redis.quit
		end

		def generate_for_request(request)
			token = SecureRandom.uuid
			key = token_key(request)
			@redis.sadd(key, token)
			@redis.expire(key, FIVE_MINUTES)

			return token
		end

		def generate_for_android(request)
			token = SecureRandom.uuid
			key = android_token_key(request)
			@redis.sadd(key, token)
			@redis.expire(key, ANDROID_TIMEOUT)

			return token
		end

		def generate_for_ios(request)
			token = SecureRandom.uuid
			key = ios_token_key(request)
			@redis.sadd(key, token)
			@redis.expire(key, IOS_TIMEOUT)

			return token
		end

		def touch(request)
			@redis.expire(token_key(request), FIVE_MINUTES)
		end

		def validate_token(request, token)
			# puts "Validating token #{token}"
			@redis.expire(token_key(request), FIVE_MINUTES)
			@redis.smembers(token_key(request)).include?(token) || @redis.smembers(android_token_key(request)).include?(token) || @redis.smembers(ios_token_key(request)).include?(token)
		end

		private

		def token_key(request)
			"ip:#{request.ip}"
		end

		def android_token_key(request)
			"android:#{request.ip}"
		end

		def ios_token_key(request)
			"ios:#{request.ip}"
		end

	end
