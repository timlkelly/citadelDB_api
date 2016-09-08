class ChangeCitadelTableSystemsToHaveAssociation < ActiveRecord::Migration
  def change
    remove_column(:citadels, :system)
    add_column(:citadels, :system_id, :integer)
  end
end
