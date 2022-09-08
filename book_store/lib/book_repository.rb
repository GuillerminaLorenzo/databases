require_relative './database_connection'
require_relative './book'

class BookRepository
  def all
    books = []

    result_set = DatabaseConnection.exec_params('SELECT id, title, author_name FROM books;', [])
    result_set.each do |record|
      book = Book.new
      book.id = record['id']
      book.title = record['title']
      book.author_name = record['author_name']
      books << book
    end
    return books
  end
end