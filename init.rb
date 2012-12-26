require 'rubygems'
require 'bundler/setup'

# Add gems that you want loaded here, space delimited
%w{ sinatra/base sinatra/content_for rack-flash rack/contrib rack/csrf warden data_mapper }.each {|req| require req }

# Load up your custom libs
Dir["lib/*.rb"].sort.each {|req| require_relative req }

# Load up your models, if any
Dir["models/**/*.rb"].sort.each {|req| require_relative req }

# Load up your apps.
Dir["app/*.rb"].sort.each {|req| require_relative req }