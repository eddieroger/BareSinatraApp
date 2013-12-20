require 'rubygems'
require 'bundler/setup'

# Globals
APP_ROOT = File.dirname(__FILE__)
DATABASE_URI = ENV['POSTGRESQL_URL'] || ENV['DATABASE_URL'] || "postgres://localhost/bareapp"

# Add gems that you want loaded here, space delimited
%w{ sinatra/base sinatra/content_for sinatra/config_file sinatra/respond_with sinatra/activerecord rack-flash rack/contrib rack/csrf warden securerandom open-uri json}.each {|req| require req }

# Load up your custom libs
Dir["lib/*.rb"].sort.each {|req| require_relative req }

# Load up your models, if any
# Dir["models/**/*.rb"].sort.each {|req| require_relative req }

# Load up your apps.
Dir["app/*.rb"].sort.each {|req| require_relative req }