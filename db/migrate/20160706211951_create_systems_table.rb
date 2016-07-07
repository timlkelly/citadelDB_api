class CreateSystemsTable < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.integer :region_id
      t.integer :system_id
      t.string :name

      t.timestamps null: false
    end
  end
end
