class CreateKillmailsTable < ActiveRecord::Migration
  def change
    create_table :killmails do |t|
      t.references :citadel_id
      t.integer :killmail_id
      t.json :killmail_json
    end
  end
end
