module BareApp
  class StartApp < BareApp::Base


    get '/' do
      erb "Hello, world!"
    end

    get '/protected' do
      is_authenticated?
      erb "Protected"
    end
  end
end