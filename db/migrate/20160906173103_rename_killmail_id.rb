class RenameKillmailId < ActiveRecord::Migration
  def change
   rename_column :killmails, :killmail_id, :killmail_eveid
  end
end
