class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :p1
      t.string :p2
      t.timestamps
    end
  end
end
