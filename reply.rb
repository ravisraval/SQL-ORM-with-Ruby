require_relative 'questions'
require_relative 'questions_database'


class Replies

  attr_accessor :parent_id, :subject_question_id, :user_id, :body
  def initialize(options)
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.all
    replies = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    replies
    replies.map { |reply| Replies.new(reply)}

  end

  def self.find_by_id(id)
    some_reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
       id = ?

    SQL
    # p some_user?
    # p some_question
    Replies.new(some_reply.first)
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @subject_question_id, @parent_id, @user_id, @body)
      INSERT INTO
        replies (subject_question_id, parent_id, user_id, body)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @subject_question_id, @parent_id, @user_id, @body, @id)
      UPDATE
        replies
      SET
        subject_question_id = ?, parent_id = ? , user_id = ?, body = ?
      WHERE
        id = ?
    SQL
  end



end

#
# CREATE TABLE replies (
#   id INTEGER PRIMARY KEY,
#   subject_question_id INTEGER NOT NULL,
#   parent_id INTEGER,
#   user_id INTEGER NOT NULL,
#   body STRING NOT NULL, --TEXT? SAME THING
#
#   FOREIGN KEY (subject_question_id) REFERENCES questions(id),
#   FOREIGN KEY (parent_id) REFERENCES replies(id),
#   FOREIGN KEY (user_id) REFERENCES users(id)
#
# );
