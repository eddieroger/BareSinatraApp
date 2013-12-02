module BareApp
  class CustomersApp < BareApp::Base

    before do
      puts "Processing URL: " + request.url
    end


    get '/new' do
      @new = true
      @customer = Customer.new
      erb :"customers/form"
    end

    get '/:memberID/edit/?' do
      @new = false
      @customer = Customer.first(:memberID => params[:memberID])

      if @customer.nil?
        status 404
        return
      end

      erb :"customers/form"
    end

    get '/:memberID/apps/new' do
      @new = true
      @customer = Customer.first(:memberID => params[:memberID])

      halt 404, "Unauthorized" unless !@customer.nil?

      @application = Application.new
      @application.customer = @customer

      erb :"customers/app_form"
    end

    get '/:memberID/apps/?:encodedCodeAtAppId?/?:command?', :provides => [:html, :json] do
      @customer = Customer.first(:memberID => params[:memberID])

      if @customer.nil?
        status 404
        return
      end

      if params[:encodedCodeAtAppId]

        # Just the one app
        @app = Application.first(:customer => @customer, :encodedCodeAtAppId => params[:encodedCodeAtAppId])
        if @app.nil?
          respond_to do |f|
            f.html{halt 404}
            f.json{halt 404, {:errorCode => 404, :error => "Not Found"}.to_json}
          end
        else

          if params[:command] == 'provision'
            if doProvisioning(@customer, @app)
              halt 200, {:status => "Provisioned"}.to_json
            else
              halt 500, {:status => "Error"}.to_json
            end
          else
           respond_to do |f|
              f.html {redirect "/customers/#{@customer.memberID}"}
              f.json {{:customer => @customer, :application => @app}.to_json}
            end
          end
        end

      else

        # All apps for customer
        # return {:applications => @customer.applications}.to_json
        respond_to do |f|
          f.html {erb :"customers/detail"}
          f.json {{:applications => @customer.applications}.to_json}
        end
      end
    end

    get '/?', :provides => [:html, :json] do
    	@customers = Customer.all
     	# erb :"customers/index"
      respond_to do |f|
        f.html {erb :"customers/index"}
        f.json {{:customers => @customers}.to_json}
      end
    end

    post '/:memberID/apps/?:encodedCodeAtAppId?', :provides => [:html, :json] do
      @new = params[:encodedCodeAtAppId].nil?

      @customer = Customer.first(:memberID => params[:memberID])
      halt 404, "Unauthorized" unless !@customer.nil?

      @application = Application.new
      @application.customer = @customer
      @application.name = params[:name]
      @application.encodedCodeAtAppId = params[:encodedCodeAtAppId]
      @application.platform = params[:platform]

      if @application.platform == "APNS"
        @application.credentialPassword = params[:apnsCertificatePassword]
        @application.credential = Base64.encode64(params[:apnsCertificateFile][:tempfile].read)

      elsif @application.platform == "GCM"
        @application.credential = params[:gcmApiKey]
      end

      puts @application.valid?
      puts @application.errors.to_a

      if @application.valid?
        if @application.save
          status 201
          respond_to do |f|
            f.html { redirect "/customers/#{@customer.memberID}/apps" }
            f.json { {:application => @application}.to_json }
          end
        else
          status 500
          respond_to do |f|
            f.html { redirect "/customers/#{@customer.memberID}/apps" }
            f.json { {:errors => ["Internal Server Error"]}.to_json }
          end
        end
      else
        status 400
        respond_to do |f|
          f.html {erb :"customers/app_form"}
          f.json {{:errors => @application.errors.to_a, :application => @application}.to_json}
        end
      end
    end

    post '/:memberID?/?', :provides => [:html, :json] do
      @new = params[:memberID].nil?
      # @customer = Customer.new(params)
      @customer = Customer.first_or_create(:memberID => params[:memberID])
      @customer.attributes = {:name => params[:name], :stack => params[:stack], :oauthToken => params[:oauthToken]}

      if @customer.save
        status 201
        respond_to do |f|
          f.html {redirect '/customers'}
          f.json { {:customer => @customer}.to_json }
        end
      else
        status 400
        respond_to do |f|
          f.html {erb :"customers/form"}
          f.json { {:errors => @customer.errors.to_h, :params => params}.to_json }
        end
      end
    end

    delete '/:memberID/apps/?:encodedCodeAtAppId?/?' do

      @customer = Customer.first(:memberID => params[:memberID])
      halt 404, "Customer not found" unless !@customer.nil?

      @application = Application.first(:encodedCodeAtAppId => params[:encodedCodeAtAppId])
      halt 404, "App not found" unless !@application.nil?

      if @application.destroy
        halt 204
      else
        halt 500, "Unexpected error"
      end

    end

    delete '/:memberID/?' do
      @customer = Customer.first(:memberID => params[:memberID])
      halt 404, "Customer not found" unless !@customer.nil?

      if @customer.destroy
        halt 204
      else
        halt 500, "Unexpected error"
      end
    end

    protected

    def doProvisioning(customer, application)

      # First prep the URL based on stack
      if customer.stack == 'S1' 
        fullURL = "https://app.exacttarget.com/rest/beta/push/application/#{application.encodedCodeAtAppId}"
      else
        fullURL = "https://app.#{customer.stack.downcase}.exacttarget.com/rest/beta/push/application/#{application.encodedCodeAtAppId}";
      end

      # fullURL = "http://requestb.in/p2bj2ap2"

      # Then the payload by platform
      if application.platform == 'APNS'
        configPayload = {:iosEndpointType => 'APNS', :apnsCertificate => application.credential, :apnsCertificatePassword => application.credentialPassword}
      elsif application.platform == 'GCM'
        configPayload = {:androidEndpointType => 'GCM', :androidEndpoint => "https://android.googleapis.com/gcm/send", :gcmApiKey => application.credential}
      end

      # @result = HTTParty.post(fullURL.to_str, {:body => configPayload.to_json, :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => "OAuth oauth_token=#{customer.oauthToken}"}})
      # puts @result.inspect

      # status 200
      # return {:done => true}

      # Then do the request
      # uri = URI.parse("https://requestb.in") # later, fullURL
      uri = URI.parse(fullURL) # later, fullURL
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = :SSLv3
      request = Net::HTTP::Post.new(uri.path)
      request.add_field('Authorization', "OAuth oauth_token=#{customer.oauthToken}")
      request.add_field('Accept', 'application/json')
      request.add_field('Content-Type', 'application/json')
      request.add_field('Accept-Encoding', 'gzip;q=0,deflate,sdch')
      request.body = {:id => application.encodedCodeAtAppId, :configuration => configPayload}.to_json

      puts "POSTing to #{uri}"
      # puts "OAuth: #{customer.oauthToken}"
      # puts "Payload: #{{:id => application.encodedCodeAtAppId, :configuration => configPayload}.to_json}"
      response = http.request(request)
      puts "POST complete."

      if response.class == Net::HTTPSuccess
        return true
      else
        return false
      end

    end

  end
end

class Net::HTTPResponse

end
