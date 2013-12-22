class EnableUuidOsspPostgres < ActiveRecord::Migration

	def change
		enable_extension 'uuid-ossp'
	end

end
