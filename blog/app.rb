require_relative 'lib/database_connection'
require_relative 'lib/post_repository'
require_relative 'lib/post'
require_relative 'lib/comment'

class Application
  def initialize(database_name, io, post_repository)
    DatabaseConnection.connect('blog_database')
    @io = io
    @post_repository = post_repository
  end

  def run
    @io.puts "Welcome to the blog directory manager!"
    @io.puts "Which post would you like to print?"
    post_id = @io.gets.chomp
    post =  @post_repository.find_with_comment(post_id)
    @io.puts "#{post.title}"
    @io.puts "Here's the list of comments in that post:"
    num = 1
      post.comment.each do |comments|
        puts "#{num}. #{comments.comment_content}, by: #{comments.author}"
        num +=1
      end
  end
end

if __FILE__ == $0
  app = Application.new(
    'blog_database',
    Kernel,
    PostRepository.new
  )
  app.run
end