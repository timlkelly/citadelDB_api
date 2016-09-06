class RenameRegionIdOnRegion < ActiveRecord::Migration
  def change
    rename_column :regions, :region_id, :region_eveid
  end
end
