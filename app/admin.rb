module BareApp
  class AdminApp < BareApp::Base

  	before do
  		is_authenticated? 
  		redirect '/' unless is_admin?
  	end

    get '/redis' do
      # erb :"start/index"
      redis = AuthenticationTokens.instance.redis

      @keys = redis.keys
      @all_data = {}
      @keys.each do |key|
      	puts redis.smembers(key)
      	@all_data[key] = redis.smembers(key)
      end

      erb :"debug/redis"
    end

    get '/apps' do
    	@apps = Application.all(:order => [ :name ])
    	erb :"debug/apps"
    end
    
  end
end