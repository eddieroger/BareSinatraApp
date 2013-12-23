class AddTokenBelongsToUser < ActiveRecord::Migration
  def up	
  	add_column :api_tokens, :user_id, :uuid
  end

  def down
  	remove_column :api_tokens, :user_id
  end
end
