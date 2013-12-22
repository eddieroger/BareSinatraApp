class CreateUser < ActiveRecord::Migration
	def change
		create_table :users, id: :uuid do |t|
			t.string 	:username
			t.string	:password_digest
			t.string	:first_name
			t.string	:last_name
			t.boolean	:admin, :default => false
			t.boolean	:approved, :default => false
			t.text		:remember_token

			t.timestamps
		end
	end
end
