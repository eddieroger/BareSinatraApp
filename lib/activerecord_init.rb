## 
# Sets up ActiveRecord and connects to it. Hopefully. 
#
# Note that URI is coming from init.rb. Trying to compartmentalize. 
##
##

db = URI.parse(DATABASE_URI)

ActiveRecord::Base.establish_connection(
	:adapter 	=> db.scheme == 'postgres' ? 'postgresql' : db.scheme,
	:host 		=> db.host,
	:username	=> db.user,
	:password	=> db.password,
	:database 	=> db.path[1..-1],
	:encoding 	=> 'utf8'
)