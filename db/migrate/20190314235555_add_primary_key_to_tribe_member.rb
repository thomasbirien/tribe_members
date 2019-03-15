class AddPrimaryKeyToTribeMember < ActiveRecord::Migration[5.2]
  def change
    add_column :tribe_members, :id, :primary_key
  end
end
