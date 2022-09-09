class Post
    # Replace the attributes by your own columns.
    attr_accessor :id, :title, :content, :comment
    def initialize
        @comment = []
    end
end