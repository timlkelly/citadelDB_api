class CreateKillmailsTable < ActiveRecord::Migration
  def change
    create_table :killmails do |t|
      t.references :citadel
      t.integer :killmail_id
      t.json :killmail_json
    end
  end
end
