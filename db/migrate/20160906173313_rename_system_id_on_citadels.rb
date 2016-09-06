class RenameSystemIdOnCitadels < ActiveRecord::Migration
  def change
    rename_column :citadels, :system_id, :system_eveid
  end
end
