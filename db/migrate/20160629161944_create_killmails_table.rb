class CreateKillmailsTable < ActiveRecord::Migration
  def change
    create_table :killmails do |t|
      t.references :citadel
      t.integer :killmail_id
      t.json :killmail_json
      
      t.timestamps null: false
    end
  end
end
