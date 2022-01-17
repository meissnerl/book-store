require 'rails_helper'

RSpec.describe Book, type: :model do
  before do
    @author1 = Author.create(first_name: "Logan", last_name: "Meissner")
    @author2 = Author.create(first_name: "Foo", last_name: "Bar")
    @author3 = Author.create(first_name: "Keith", last_name: "Richardson")
    @author4 = Author.create(first_name: "Bill", last_name: "Test")
    
    @publisher1 = Publisher.create(name: "pub1")
    @publisher2 = Publisher.create(name: "pub2")
    @publisher3 = Publisher.create(name: "test")
    
    @format1 = BookFormatType.create(name: "type1", physical: true)
    @format2 = BookFormatType.create(name: "type2", physical: false)
    @format3 = BookFormatType.create(name: "type3", physical: true)
    @format4 = BookFormatType.create(name: "type4", physical: false)
    
    @book1 = Book.create(title: "test", publisher: @publisher1, author: @author1, book_format_types: [@format1, @format2])
    @book2 = Book.create(title: "test2", publisher: @publisher2, author: @author4, book_format_types: [@format3, @format4])
    @book3 = Book.create(title: "Bar", publisher: @publisher3, author: @author2, book_format_types: [@format1, @format3])
    @book4 = Book.create(title: "Barring", publisher: @publisher2, author: @author4, book_format_types: [@format1])
    
    BookReview.create(book: @book1, rating: 1)
    BookReview.create(book: @book1, rating: 4)
    BookReview.create(book: @book1, rating: 3)
    
    BookReview.create(book: @book2, rating: 3)
    BookReview.create(book: @book2, rating: 2)
    BookReview.create(book: @book2, rating: 5)
    
    BookReview.create(book: @book3, rating: 4)
    BookReview.create(book: @book3, rating: 4)
    BookReview.create(book: @book3, rating: 4)
    
    BookReview.create(book: @book4, rating: 1)
    BookReview.create(book: @book4, rating: 5)
    BookReview.create(book: @book4, rating: 1)
  end

  describe "validation" do
    it "book is invalid if title is nil" do
      @book1 = Book.create(title: nil, publisher: @publisher1, author: @author1, book_format_types: [@format1, @format2])

      expect(@book1.valid?).to eq(false)
    end

    it "book is invalid if title is empty" do
      @book1 = Book.create(title: "", publisher: @publisher1, author: @author1, book_format_types: [@format1, @format2])

      expect(@book1.valid?).to eq(false)
    end

    it "book is invalid if author is nil" do
      @book1 = Book.create(title: "book", publisher: @publisher1, author: nil, book_format_types: [@format1, @format2])

      expect(@book1.valid?).to eq(false)
    end

    it "book is invalid if publisher is nil" do
      @book1 = Book.create(title: "book", publisher: nil, author: @author1, book_format_types: [@format1, @format2])

      expect(@book1.valid?).to eq(false)
    end

    it "book is valid if title, author and publisher aren't nil or blank" do
      @book1 = Book.create(title: "book", publisher: @publisher1, author: @author1, book_format_types: [@format1, @format2])

      expect(@book1.valid?).to eq(true)
    end
  end

  describe "average_rating" do
    it "returns the average of the book reviews rounded to one decimal point" do
      result = @book1.average_rating

      expect(result).to eq(2.7)
    end
  end

  describe "author_name" do
    it "returns the authors name in (lastname, firstname) format" do
      result = @book1.author_name

      expect(result).to eq("Meissner, Logan")
    end
  end


  describe "search" do
    it "finds all books with exact mathes for author, publishers, and non exact matches for title when title_only is false" do
      result = Book.search("test")

      expect(result.count).to eq(4)
      expect(result).to include(@book1)
      expect(result).to include(@book2)
      expect(result).to include(@book3)
      expect(result).to include(@book4)
    end

    it "finds all books with titles that contain query when title_only is true" do
      result = Book.search("test", title_only: true)

      expect(result.count).to eq(2)
      expect(result).to include(@book1)
      expect(result).to include(@book2)
    end

    it "finds all books with titles that contain case insensitive query when title_only is true" do
      result = Book.search("TeSt", title_only: true)

      expect(result.count).to eq(2)
      expect(result).to include(@book1)
      expect(result).to include(@book2)
    end

    it "finds all books with titles that contain query when title_only is true and that contains the matching format id from book_format_type_id being set" do
      result = Book.search("test", book_format_type_id: 2)

      expect(result.count).to eq(1)
      expect(result).to include(@book1)
    end

    it "finds all books with exact mathes for author, publishers, and non exact matches for title when title_only is false and format physical boolean from book_format_type_physical bring set" do
      result = Book.search("test", book_format_physical: false)

      expect(result.count).to eq(2)
      expect(result).to include(@book1)
      expect(result).to include(@book2)
    end

    it "returns a list of books in order of average review rating from highest to lowest" do
      result = Book.search("test")

      expect(result.count).to eq(4)
      expect(result.map {|book| book.average_rating}).to eq([4.0, 3.3, 2.7, 2.3])
    end

    it "returns nothing if author last name isn't an exact match" do
      result = Book.search("Meis")

      expect(result.count).to eq(0)
    end

    it "returns nothing if publisher name isn't an exact match" do
      result = Book.search("pub")

      expect(result.count).to eq(0)
    end

    it "returns only exact matches on author last name in query" do
      result = Book.search("Meissner")

      expect(result.count).to eq(1)
      expect(result).to include(@book1)
    end

    it "returns only exact matches publisher name in query" do
      result = Book.search("pub1")

      expect(result.count).to eq(1)
      expect(result).to include(@book1)
    end
  end
end
