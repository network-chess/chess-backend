class AddPlayerToMove < ActiveRecord::Migration
  def change
    add_column :moves, :player, :string
  end
end
