module BareApp
  class Base < Sinatra::Base
    register Sinatra::Warden
    register Sinatra::ConfigFile
    register Sinatra::RespondTo
    helpers Sinatra::CsrfHelper
    helpers Sinatra::BareAppHelper

    use Rack::Flash

    config_file File.join(APP_ROOT, 'app.yaml')

    configure do
      set :raise_errors, false
      set :dump_errors, true
      set :methodoverride, true
      set :show_exceptions, false
      set :static, true
      set :static_cache_control, [:public, :max_age => 1800]
      set :views, "views"
      set :logging, true
      set :public_folder, 'public'
      enable :logging
      enable :session

    end

    use Warden::Manager do |manager|
      manager.default_strategies :cookie, :password, :api
      manager.failure_app = BareApp::AuthenticationApp
      manager.serialize_into_session {|user| user.id}
      manager.serialize_from_session {|id| User.find_by(id: id)}
    end # Warden::Manager

    before do
      @app_name = settings.app_name
        if request.path.include?('login') && request.request_method == 'POST'
          puts "Request POST - Login request. Not logged."
        else
          puts "Request #{request.request_method} incoming from #{request.ip} to #{request.url} with params: #{params}"
        end
      # puts "\tUser-Agent: #{request.user_agent}"
    end

  end # Base
end # BareApp