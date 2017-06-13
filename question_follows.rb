class Question_follows



end


# CREATE TABLE question_follows (
#   id INTEGER PRIMARY KEY,
#   question_id INTEGER NOT NULL,
#   user_id INTEGER NOT NULL,
#   FOREIGN KEY (user_id) REFERENCES users(id),
#   FOREIGN KEY (question_id) REFERENCES questions(id)
#
# );
#
# INSERT INTO
#   question_follows(question_id, user_id)
#   VALUES
#   (1, 2);
