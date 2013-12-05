module BareApp
  class StartApp < BareApp::Base


    get '/' do
      # erb :"start/index"
      redirect "/apps"
    end
    
  end
end