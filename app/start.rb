module BareApp
  class StartApp < BareApp::Base


    get '/' do
    	respond_to do |format|
    		format.html { haml :"start/index" }
    		format.json { {:status => "OK"}.to_json }
    	end
    end

    get '/protected' do
    	authenticate!
    	respond_to do |format|
    		format.html { haml :'start/protected'}
    		format.json { {:protected => true, :access => true}.to_json }
    	end
    end
  end
end