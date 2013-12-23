require 'rubygems'
require 'bundler'
Bundler.setup

require './init'

use Rack::Cookies # For rememberable warden strategy
use Rack::Session::Cookie, :secret => "youarenowchangedlikeasaperson123"

# Parses the request body to JSON and fakes out a form POST -- ie, forcing a JSON post to params
use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode body }
}

run Rack::URLMap.new(
    '/'	=> BareApp::StartApp.new,
    '/auth'		=> BareApp::AuthenticationApp.new
    )