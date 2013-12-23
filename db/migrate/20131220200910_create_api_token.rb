class CreateApiToken < ActiveRecord::Migration

	def change
		create_table :api_tokens, id: :uuid do |t|
			t.string :token
			t.string :name
			t.boolean :active, :default => true
			t.belongs_to :user

			t.timestamps
		end
	end

end
