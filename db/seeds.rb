# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author1 = Author.create(first_name: "Logan", last_name: "Meissner")
author2 = Author.create(first_name: "Foo", last_name: "Bar")
author3 = Author.create(first_name: "Keith", last_name: "Richardson")
author4 = Author.create(first_name: "Bill", last_name: "Test")

publisher1 = Publisher.create(name: "pub1")
publisher2 = Publisher.create(name: "pub2")
publisher3 = Publisher.create(name: "test")

format1 = BookFormatType.create(name: "type1", physical: true)
format2 = BookFormatType.create(name: "type2", physical: false)
format3 = BookFormatType.create(name: "type3", physical: true)
format4 = BookFormatType.create(name: "type4", physical: false)

book1 = Book.create(title: "test", publisher: publisher1, author: author1, book_format_types: [format1, format2])
book2 = Book.create(title: "test2", publisher: publisher2, author: author4, book_format_types: [format3, format4])
book3 = Book.create(title: "Bar", publisher: publisher3, author: author2, book_format_types: [format1, format3])
book4 = Book.create(title: "Barring", publisher: publisher2, author: author3, book_format_types: [format1])

BookReview.create(book: book1, rating: 1)
BookReview.create(book: book1, rating: 4)
BookReview.create(book: book1, rating: 3)

BookReview.create(book: book2, rating: 3)
BookReview.create(book: book2, rating: 2)
BookReview.create(book: book2, rating: 5)

BookReview.create(book: book3, rating: 4)
BookReview.create(book: book3, rating: 4)
BookReview.create(book: book3, rating: 4)

BookReview.create(book: book4, rating: 2)
BookReview.create(book: book4, rating: 5)
BookReview.create(book: book4, rating: 1)