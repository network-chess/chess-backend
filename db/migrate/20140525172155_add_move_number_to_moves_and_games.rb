class AddMoveNumberToMovesAndGames < ActiveRecord::Migration
  def change
    add_column :moves, :move_number, :integer
    add_column :games, :move_number, :integer
  end
end
