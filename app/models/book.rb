class Book < ApplicationRecord
    belongs_to :author
    belongs_to :publisher

    has_many :book_formats
    has_many :book_format_types, through: :book_formats

    has_many :book_reviews

    validates :author, :presence => true
    validates :publisher, :presence => true
    validates :title, :presence => true

    def author_name
        return "#{self.author.last_name}, #{self.author.first_name}"
    end

    def average_rating
        ratings = self.book_reviews.collect { |review| review.rating }
        return (ratings.sum(0.0) / ratings.size).round(1)
    end

    def self.search(query, options = {title_only: false, book_format_type_id: nil, book_format_physical: nil })
        books = Array.new

        if !options[:title_only] then
            books = Book.joins(:author).where('lower(authors.last_name) = ?', query.downcase)
            books = books + Book.joins(:publisher).where('lower(publishers.name) = ?', query.downcase)
        end

        books = books + Book.where('lower(title) like ?', "%#{query}%".downcase)

        if !options[:book_format_type_id].nil? then
            book_ids = books.map { |book| book.id }
            books = Book.joins(:book_format_types).where(:book_format_types => {:id => options[:book_format_type_id]}).where(id: book_ids)
        end

        if !options[:book_format_physical].nil? then
            book_ids = books.map { |book| book.id }
            books = Book.joins(:book_format_types).where(:book_format_types => {:physical => options[:book_format_physical]}).where(id: book_ids)
        end

        return books.uniq.sort_by {|book| book.average_rating}.reverse
    end
end
