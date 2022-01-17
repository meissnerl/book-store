class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.timestamps
      t.belongs_to :author
      t.belongs_to :publisher
      t.belongs_to :book_formats
    end

    add_reference :book_reviews, :book, index: true
    add_reference :book_formats, :book, index: true
    add_reference :book_formats, :book_format_type, index: true
  end
end
