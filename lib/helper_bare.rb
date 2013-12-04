module Sinatra
  module BareAppHelper
  	def link_to(url, text=url, opts={})
  		attributes = ""
  		opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
  		return "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  	end

  	def select_options_for_enum(model)
	  	returnMe = ""
	  	model.options[:flags].each do |value|
	  		returnMe << "<option value=\"#{value.to_s}\">#{value.to_s}</option>"
	  	end
	  
	  	return returnMe	
  	end

  	def admin_mode?
  		return params.keys.include?("admin")
  	end

  end

  helpers BareAppHelper
end