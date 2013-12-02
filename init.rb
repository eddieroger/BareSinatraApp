require 'rubygems'
require 'bundler/setup'

# Globals
APP_ROOT = File.dirname(__FILE__)

# Add gems that you want loaded here, space delimited
%w{ sinatra/base sinatra/content_for sinatra/config_file sinatra/respond_with rack-flash rack/contrib rack/csrf warden data_mapper dm-serializer base64 openssl httparty zlib net/http net/https}.each {|req| require req }

# Load up your custom libs
Dir["lib/*.rb"].sort.each {|req| require_relative req }

# Load up your models, if any
Dir["models/**/*.rb"].sort.each {|req| require_relative req }

# Load up your apps.
Dir["app/*.rb"].sort.each {|req| require_relative req }