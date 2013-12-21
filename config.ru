require 'rubygems'
require 'bundler'
Bundler.setup

require './init'

use Rack::Cookies # For rememberable warden strategy
use Rack::Session::Cookie, :secret => "youarenowchangedlikeasaperson123"


run Rack::URLMap.new(
    '/'	=> BareApp::StartApp.new,
    '/auth'		=> BareApp::AuthenticationApp.new
    )