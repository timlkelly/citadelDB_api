class AddRegionToCitadelsTable < ActiveRecord::Migration
  def change
    add_column(:citadels, :region, :string)
  end
end
