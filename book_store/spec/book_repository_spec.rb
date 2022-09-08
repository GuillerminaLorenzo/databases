require 'book_repository'

RSpec.describe BookRepository do 
  def reset_books_table
    seed_sql = File.read('spec/seeds_books.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
    connection.exec(seed_sql)
  end

  describe BookRepository do
    before(:each) do 
      reset_books_table
    end

    it 'lists all books in the repository and accesses its title and author name' do
      book_repo = BookRepository.new

      books = book_repo.all

      expect(books.length).to eq 2
      expect(books[0].id).to eq '1'
      expect(books[0].title).to eq 'Nineteen Eighty-Four'
      expect(books[0].author_name).to eq 'George Orwell'
    end
  end

end