class RemoveRegionFromCitadels < ActiveRecord::Migration
  def change
    remove_column(:citadels, :region)
  end
end
