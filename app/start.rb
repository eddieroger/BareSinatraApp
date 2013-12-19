module BareApp
  class StartApp < BareApp::Base


    get '/' do
      erb :"start/index"
    end
    
  end
end