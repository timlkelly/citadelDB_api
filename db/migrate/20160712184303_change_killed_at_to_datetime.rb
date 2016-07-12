class ChangeKilledAtToDatetime < ActiveRecord::Migration
  def change
    remove_column(:citadels, :killed_at)
    add_column(:citadels, :killed_at, :datetime)
  end
end
