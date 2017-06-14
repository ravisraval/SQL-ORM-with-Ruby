require_relative 'questions.rb'
require_relative 'question_follows'
require_relative 'questions_database'
require_relative 'reply'


class QuestionLikes
  attr_accessor :likes, :user_id, :question_id

  def self.all
    q_likes = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    q_likes.map { |q_like| QuestionLikes.new(q_like) }
  end

  def self.find_by_id(id)
    q_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    Question_likes.new(q_likes.first)
  end

  def self.likers_for_question_id(question_id)
    likppl = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      JOIN
        questions ON questions.id = question_likes.question_id
      WHERE
        question_likes.question_id = ?
    SQL
    likppl.map { |usr| Users.new(usr) }
  end

  def self.num_likes_for_question_id(question_id)
    likppl = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      JOIN
        questions ON questions.id = question_likes.question_id
      WHERE
        question_likes.question_id = ?
    SQL
    likppl.first.values.first
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @likes = options['likes']
  end


  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, likes, user_id, question_id)
      INSERT INTO
        question_likes (likes, user_id, question_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, likes, user_id, question_id, id)
      UPDATE
        question_likes
      SET
        likes = ?, user_id = ?, question_id = ?
      WHERE
        id = ?
    SQL
  end





end
  # INSERT INTO
  #   question_likes(likes, user_id, question_id)
  # VALUES
  #   (4, 1, 2),
  #   (100, 2, 1);
