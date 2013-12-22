module BareApp
  class StartApp < BareApp::Base


    get '/' do
      haml :"start/index"
    end
    
  end
end