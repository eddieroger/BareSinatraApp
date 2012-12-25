require './init'

use Rack::Session::Cookie, :secret => "pleasepleasepleasechangeme"

run Rack::URLMap.new (
  # <path>, => <module>::<app>.new

)