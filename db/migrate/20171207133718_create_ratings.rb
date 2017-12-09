class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.decimal :Rating
      t.text :Review, null: true
      t.belongs_to :user, index: true
      t.belongs_to :movie, index: true
      t.timestamps
    end
    add_index :ratings, [:user_id, :movie_id], unique: true
  end
end
