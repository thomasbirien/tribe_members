class CreateModelStat < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
      t.integer :total_member
      t.text :older
      t.text :average
    end
  end
end
