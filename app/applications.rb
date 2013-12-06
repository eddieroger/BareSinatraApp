module BareApp
  class ApplicationApp < BareApp::Base
 
    before do
      authenticate! unless warden.authenticated?
      @sessionToken = AuthenticationTokens.instance.generate_for_request(request) unless !warden.authenticated?

    end

  	get '/version/new/?' do
      is_authenticated?
      redirect '/' unless is_admin?

  		@new = true
  		@applications = Application.all(:order => [ :name ])
  		@version = Version.new
  		erb :"apps/form_version"
  	end	

  	get '/new/?' do
      is_authenticated?
      redirect '/' unless is_admin?

  		@new = true
  		@app = Application.new
  		erb :"apps/form_app"
  	end

  	get '/:app_id/?:command?/?' do
      is_authenticated?

  		@app = Application.get(params[:app_id])
  		# halt 404 unless !@app.nil?

  		case params[:command]
  		when "edit"
        puts 'edit'
  			@new = false
  			if @app.nil? 
  				halt 404
  			end
  			erb :"apps/form_app"

  		when "plist"
        content_type :plist
        erb :"apps/plist", :layout => false

  		when "ipa"
        content_type :ipa
        headers["Content-Disposition"] = "attachment;filename=#{@app.most_recent_ios_version.ipa_filename || 'app.ipa'}"
        return Base64.decode64(@app.most_recent_ios_version.encoded_ipa)

  		when "apk"
        content_type :apk
        headers["Content-Disposition"] = "attachment;filename=#{@app.most_recent_android_version.apk_filename || 'app.apk'}"
        return Base64.decode64(@app.most_recent_android_version.encoded_apk)
  			
      when "icon"
        content_type :png
        
        if @app.icon
          return Base64.decode64(@app.icon)
        else
          send_file File.join(APP_ROOT, '/public/img/x.png')
        end
  		end

  	end

  	post '/version/?:version_id?/?new?' do
      is_authenticated?
      redirect '/' unless is_admin?
      
  		@applications = Application.all
  		
  		if params[:version_id]
  			
  		else
  			puts params
  			@version = Version.new
  			@version.application = Application.get(params[:app_id])
  			@version.version_number = params[:version_number]
        @version.platform = params[:platform]
  			@version.bundle_identifier = params[:bundle_identifier]

  			@version.encoded_ipa = Base64.encode64(params[:ipa_file][:tempfile].read) unless params[:ipa_file].nil?
        @version.ipa_filename = params[:ipa_file][:filename] unless params[:ipa_file].nil?

  			@version.encoded_apk = Base64.encode64(params[:apk_file][:tempfile].read) unless params[:apk_file].nil?
        @version.apk_filename = params[:apk_file][:filename] unless params[:apk_file].nil?

  			if @version.valid?
  				if @version.save
  					status 201
  					redirect '/admin/apps'
  				else
  					halt 500
  				end
  			else
  				status 400
  				erb :"apps/form_version"
  			end

  		end

  	end

  	post '/:app_id?' do
      is_authenticated?
      redirect '/' unless is_admin?

  		@app = Application.first_or_create(:id => params[:app_id])
  		@app.name = params[:name]
      @app.description = params[:description]
      @app.icon = Base64.encode64(params[:icon_file][:tempfile].read) unless params[:icon_file].nil?

  		if @app.valid?
  			if @app.save
  				status 201	
  				redirect '/admin/apps'
  			else	
  				halt 500
  			end
  		else
  			status 400
  			erb :"apps/form_app"
  		end
  	end

    get '/' do
      is_authenticated?
      
    	@applications = Application.all
      	erb :"apps/index"
    end

  end
end