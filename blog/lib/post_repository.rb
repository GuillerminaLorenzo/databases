require_relative 'post'
require_relative 'comment'

class PostRepository
    def find_with_comment(post_id)
        sql = 'SELECT posts.id AS "id",
                    posts.title AS "title",
                    comments.comment_content AS "comment_content",
                    comments.author AS "author"
                FROM posts
                    JOIN comments
                    ON posts.id = comments.post_id
                WHERE posts.id = $1;'
        params = [post_id]
        result = DatabaseConnection.exec_params(sql, params)

        first_record = result[0]
        post = record_to_post_object(first_record)

        result.each do |record|
            post.comment << record_to_comment_object(record)
        end 
    post
    end
   

    private

    def record_to_post_object(record)
        post = Post.new
        post.id = record['id']
        post.title = record['title']

        return post
    end

    def record_to_comment_object(record)
        comment = Comment.new
        comment.comment_content = record['comment_content']
        comment.author = record['author']

        return comment
    end
end