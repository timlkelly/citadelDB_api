class CreateCitadelsTable < ActiveRecord::Migration
  def change
    create_table :citadels do |t|
      t.string :system
      t.string :citadel_type
      t.string :corporation
      t.string :alliance
      t.string :killed_at

      t.timestamps null: false
    end
  end
end
