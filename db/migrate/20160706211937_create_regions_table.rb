class CreateRegionsTable < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :region_id
      t.string :name

      t.timestamps null: false
    end
  end
end
