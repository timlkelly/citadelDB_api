class RenameSystemAndRegionIdOnSystems < ActiveRecord::Migration
  def change
    rename_column :systems, :system_id, :system_eveid
    rename_column :systems, :region_id, :region_eveid
  end
end
