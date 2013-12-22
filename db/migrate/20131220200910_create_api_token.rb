class CreateApiToken < ActiveRecord::Migration

	def change
		create_table :apitokens, id: :uuid do |t|
			t.string :token
			t.boolean :active, :default => true

			t.timestamps
		end
	end

end
