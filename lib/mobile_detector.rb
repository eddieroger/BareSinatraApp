module Sinatra
	class Request
		def is_mobile?
			self.user_agent.include?("iPhone") || self.user_agent.include?("iPad") || self.user_agent.include?("Android")
		end

		def is_ios_device?
			self.user_agent.include?("iPhone") || self.user_agent.include?("iPad") 
		end

		def is_android_device?
			self.user_agent.include?("Android")			
		end
	end
end