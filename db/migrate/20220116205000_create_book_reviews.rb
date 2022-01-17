class CreateBookReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :book_reviews do |t|
      t.integer :rating, null: false
      t.timestamps
    end
  end
end
