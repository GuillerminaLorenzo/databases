require 'post'
require 'comment'
require 'post_repository'

describe PostRepository do
    def reset_blog_table
        seed_sql = File.read('spec/seeds_blog.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'blog_database' })
        connection.exec(seed_sql)
    end
    before(:each) do 
        reset_blog_table
    end
    it 'find a post with its comments' do
        repo = PostRepository.new
        post = repo.find_with_comment('1')

        expect(post.id).to eq '1'
        expect(post.title).to eq 'AAA'
        expect(post.comment.length).to eq 2
    end
end