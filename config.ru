require 'rubygems'
require 'bundler'
Bundler.setup

require './init'

use Rack::Cookies # For rememberable warden strategy
use Rack::Session::Cookie, :secret => "pleasepleasepleasechangeme"


run Rack::URLMap.new(
    '/'	=> BareApp::StartApp.new,
    '/apps' 	=> BareApp::ApplicationApp,
    '/auth'		=> BareApp::AuthenticationApp.new
    )