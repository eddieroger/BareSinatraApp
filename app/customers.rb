module BareApp
  class CustomersApp < BareApp::Base


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
          respond_to do |f|
            f.html {redirect "/customers/#{@customer.memberID}"}
            f.json {@app.to_json}
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

  	# get	'/:memberID/?' do
  	# 	@customer = Customer.first(:memberID => params[:memberID])

  		
  	# 	respond_to do |f|
   #      f.html {erb :"customers/detail"}
   #      f.json {@customer.to_json(:methods => [:applications])}
   #    end
  	# end

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


      # puts @customer
      # puts params
      # if @customer.valid?
      #   puts "Valid"
      #   if @customer.save
      #     puts "Saved"
      #     status 201
      #     respond_to do |f|
      #       f.html {erb :"customers/index"}
      #       f.json { {:customer => @customer}.to_json }
      #     end
      #   else
      #     puts "Failed - 500"
      #     status 500
      #     return {:error => "Failed to save"}.to_json
      #   end
      # else
      #   puts "Failed - 400"
      #   status 400
      #   respond_to do |f|
      #     f.html {erb :"customers/form"}
      #     f.json { {:errors => @customer.errors.to_h, :params => params}.to_json }
      #   end
      # end
    end

  end
end