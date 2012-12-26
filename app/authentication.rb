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
      flash[:success] = "You have been logged out. Thanks for visiting!"
      redirect('/')
    end

    get '/bye' do
      erb :"auth/bye", :layout => :authentication_app
    end

    post '/unauthenticated/?' do
      puts "Unauthenticaeted"
      flash[:error] = "Failed to log in"
      redirect '/auth/login'
    end

    ## Signup
    get '/register' do
      @new_user = true
      @user = User.new
      erb :"auth/signup"
    end

    post '/register' do
      puts params
      @new_user = true
      @user = User.new(:email => params[:"user.email"],
                        :password => params[:"user.password"],
                        :password_confirmation => params[:"user.password_confirmation"],
                        :first_name => params[:"user.first_name"],
                        :last_name => params[:"user.last_name"])

      if @user.save
        puts "Save worked"
        redirect '/'
      else
        puts "Save failed"
        puts @user
        flash[:error] = @user.errors.full_messages.join("<br/>")
        erb :"auth/signup"
      end
    end
  end
end
