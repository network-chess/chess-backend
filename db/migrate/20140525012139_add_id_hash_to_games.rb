class AddIdHashToGames < ActiveRecord::Migration
  def change
    add_column :games, :idhash, :string
  end
end
