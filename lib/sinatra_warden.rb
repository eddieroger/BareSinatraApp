#require 'warden'
#require 'sinatra'

Warden::Manager.serialize_into_session { |user| user.id }
Warden::Manager.serialize_from_session { |id| User.get(id) }

Warden::Manager.before_failure do |env, opts|
  puts "Failure"
  env['rack.session']['return_to'] ||= opts[:attempted_path] # may need more to get the query string
end

module Sinatra

  module Warden
    module Helpers
      def warden
        env['warden']
      end

      def authenticate!(*args)
        env['warden'].authenticate! # (:token, :password, :cookie)
      end

      def current_user
        env['warden'].user
      end

      def is_authenticated?
        if !warden.authenticated?

          env['rack.session']['redirect_to'] = request.path
          redirect '/auth/login'
        end
      end

      def is_admin?
        if env['warden'].user
          return env['warden'].user.admin
        else
          return false
        end
      end
    end

    def self.registered(app)
      app.helpers Warden::Helpers

      # # Enable Sessions
      # app.set :sessions, true

      # Setting this to true will store last request URL
      # into a user's session so that to redirect back to it
      # upon successful authentication
      app.set :auth_use_referrer, true

      app.set :auth_error_message,   "Could not log you in."
      app.set :auth_success_message, "You have logged in successfully."

    end
  end # Warden

  register Warden
end