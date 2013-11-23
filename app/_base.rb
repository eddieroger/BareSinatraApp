module BareApp
  class Base < Sinatra::Base
    register Sinatra::Warden
    register Sinatra::ConfigFile
    helpers Sinatra::CsrfHelper
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
      manager.default_strategies(:cookie, :password)
      manager.failure_app = BareApp::AuthenticationApp
      manager.serialize_into_session {|user| user.id}
      manager.serialize_from_session {|id| User.get(id)}
    end # Warden::Manager

    before do
      @app_name = settings.app_name
    end

  end # Base
end # BareApp