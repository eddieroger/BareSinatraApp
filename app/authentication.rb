require 'rack-flash'

module BareApp
  class AuthenticationApp < BareApp::Base

    configure do

    end

    get '/login' do
      erb :"auth/login", :layout => :authentication_app
    end

    post '/login' do
      # check credentials for login
      env['warden'].authenticate!
      flash[:success] = "You have been logged in!"
      if env['rack.session']['return_to']
        redirect(env['rack.session']['return_to'])
      else
        redirect('/')
      end
    end

    get '/logout' do
      env['warden'].logout
      redirect('/auth/bye')
    end

    get '/bye' do
      erb :"auth/bye", :layout => :authentication_app
    end

    post '/unauthenticated/?' do
      "Unauthenticaeted"
    end
  end
end
