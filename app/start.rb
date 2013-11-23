module BareApp
  class StartApp < BareApp::Base


    get '/' do
      redirect '/customers'
    end

    get '/protected' do
      is_authenticated?
      erb "Protected"
    end
  end
end