module BareApp
  class DeviceApp < BareApp::Base

    before do
        authenticate! unless warden.authenticated?    
    end

    get '/apps/:app_id/version' do
    	@app = Application.get(params[:app_id])
    	# halt 404 unless !@app.nil?


    	if params[:platform] == 'ios'
    		@version = @app.most_recent_ios_version
            authToken = AuthenticationTokens.instance.generate_for_ios(request)
            update_url = "itms-services://?action=download-manifest&url=#{request.scheme}://#{request.host}/apps/#{@app.id}/plist%3FauthToken%3D#{authToken}"
    	elsif params[:platform] == 'android'
    		@version = @app.most_recent_android_version
    		authToken = AuthenticationTokens.instance.generate_for_android(request)
    		update_url = "#{request.scheme}://#{request.host}/apps/#{@app.id}/apk?authToken=#{authToken}"
    	end

    	content_type :json
      	{:version => @version.version_number.to_s, :update_url => update_url}.to_json
    end
    
  end
end