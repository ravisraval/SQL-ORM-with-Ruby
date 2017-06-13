require_relative 'questions'
require_relative 'questions_database'


class QuestionFollows
  attr_accessor :question_id, :user_id


  def self.all
    all_q_f = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    all_q_f.map { |q_follow| Question_follows.new(q_follow) }
  end

  def self.find_by_id(id)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    Question_follows.new(q_follow.first)
  end

  def self.followers_for_question_id(question_id)
    user_follows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        questions.id = ?
    SQL
    user_follows.map { |user| Users.new(user) }

  end


  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id)
      INSERT INTO
        question_follows (question_id, user_id)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @id)
      UPDATE
        questions
      SET
        question_id = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end



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
