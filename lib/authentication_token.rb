
	class AuthenticationTokens	
		include Singleton

		attr_reader :redis

		FIVE_MINUTES = 60 * 5

		def initialize
			ENV['REDIS_URL'] ||= 'redis://localhost:6379'
			uri = URI.parse(ENV['REDIS_URL'])
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

			token
		end

		def touch(request)
			@redis.expire(token_key(request), FIVE_MINUTES)
		end

		def validate_token(request, token)
			@redis.expire(token_key(request), FIVE_MINUTES)
			@redis.smembers(token_key(request)).include?(token)
		end

		private

		def token_key(request)
			"ip:#{request.ip}"
		end

	end
