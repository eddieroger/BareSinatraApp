module BareApp
  class CustomersApp < BareApp::Base


  	get	'/:memberID/?' do
  		@customer = Customer.get(1)
  		
  		erb :"customers/detail"
  	end

    get '/?' do
    	@customers = Customer.all(:sort => :memberID)
     	erb :"customers/index"
    end

  end
end