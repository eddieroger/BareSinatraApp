module BareApp
  class StartApp < BareApp::Base


    get '/' do
      # erb :"start/index"
      redirect "/apps"
    end

    get '/protected' do
      is_authenticated?
      erb "Protected"
    end
  end
end