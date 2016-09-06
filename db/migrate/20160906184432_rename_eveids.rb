class RenameEveids < ActiveRecord::Migration
  def change
    rename_column :regions, :region_eveid, :eveid
    rename_column :systems, :system_eveid, :eveid
  end
end
