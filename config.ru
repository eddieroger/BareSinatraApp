require './init'

use Rack::Cookies # For rememberable warden strategy
use Rack::Session::Cookie, :secret => "pleasepleasepleasechangeme"
use Rack::Csrf, :raise => true

run Rack::URLMap.new(
    '/'       => BareApp::StartApp.new,
    '/auth'		=> BareApp::AuthenticationApp.new

    )