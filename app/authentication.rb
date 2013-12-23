require 'rack-flash'

module BareApp
  class AuthenticationApp < BareApp::Base

    configure do

    end

    get '/login' do
      if env['warden'].authenticated?
        return "Hello"
      end
      # erb :"auth/login", :layout => :authentication_app
      haml :'auth/login', :layout => :auth
    end

    post '/login' do
      # check credentials for login
      env['warden'].authenticate!
      # flash[:success] = "You have been logged in!"

      respond_to do |format|
        format.html {
                if env['rack.session']['return_to'] && env['rack.session']['return_to'] != '/auth/login'
                 redirect(env['rack.session']['return_to'])
                else
                  redirect('/')
                end
                }
        format.json { do_json_login }
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
      respond_to do |format|
        format.html {
          flash[:error] = "Failed to log in"
          redirect '/auth/login'
        }
        format.json {
          status 401
          {:error => "Login failed."}.to_json
        }
      end
    end

    get '/unauthenticated/?' do
      respond_to do |format|
        format.html {
          flash[:error] = "Failed to log in"
          redirect '/auth/login'
        }
        format.json {
          status 401
          {:error => "Login failed."}.to_json
        }
      end
    end

    ## Signup
    # get '/register' do
    #   @new_user = true
    #   @user = User.new
    #   erb :"auth/signup"
    # end

    # post '/register' do
    #   puts params
    #   @new_user = true
    #   @user = User.new(:email => params[:"user.email"],
    #                     :password => params[:"user.password"],
    #                     :password_confirmation => params[:"user.password_confirmation"],
    #                     :first_name => params[:"user.first_name"],
    #                     :last_name => params[:"user.last_name"])

    #   if @user.save
    #     puts "Save worked"
    #     redirect '/'
    #   else
    #     puts "Save failed"
    #     puts @user
    #     flash[:error] = @user.errors.full_messages.join("<br/>")
    #     erb :"auth/signup"
    #   end
    # end

    private

    def do_html_login
      
    end

    def do_json_login
      user = env['warden'].user
      appname = params[:application] || "Unknown App"
      token = ApiToken.new(user: user, name: appname, token: ApiToken.get_new_token(32))
      token.save
      {:user => {:username => user.username, :accessToken => token.token}}.to_json
    end
  end
end
