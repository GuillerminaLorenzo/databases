TRUNCATE TABLE posts, comments RESTART IDENTITY;


INSERT INTO posts (title, content) VALUES ('AAA', 'aaa');
INSERT INTO posts (title, content) VALUES ('BBB', 'bbb');


INSERT INTO comments (author, comment_content, post_id) VALUES ('Guillermina', 'Good', '1');
INSERT INTO comments (author, comment_content, post_id) VALUES ('Christopher', 'Bad', '2');
INSERT INTO comments (author, comment_content, post_id) VALUES ('Emma', 'Very good', '1');