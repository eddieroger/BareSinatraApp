require './init'

use Rack::Session::Cookie, :secret => "pleasepleasepleasechangeme"

run Rack::URLMap.new(
    '/'       => BareApp::StartApp.new,
    '/auth'		=> BareApp::AuthenticationApp.new

    )