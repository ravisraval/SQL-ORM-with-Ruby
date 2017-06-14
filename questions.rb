require 'sqlite3'
require 'singleton'
require_relative 'questions_database'
require_relative 'question_follows'

class Questions
  attr_accessor :title, :body, :author_id
  attr_reader :id
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def self.all
    questions = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    questions
    questions.map { |question| Questions.new(question)}
  end

  def self.find_by_id(id)

    some_question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
       id = ?

    SQL
    # p some_user?
    p some_question
    Questions.new(some_question.first)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def self.find_by_title(title)
    some_question = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
       title = ?
    SQL
    # p some_user?
    Questions.new(some_question.first)
  end


  def self.find_by_author_id(author_id)
    some_questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
       author_id = ?
    SQL
    # p some_user?
    some_questions.map { |question| Questions.new(question)}
  end

  def author
    Users.find_by_id(@author_id)
  end

  def replies
    Replies.find_by_subject_question_id(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
      WHERE
        id = ?
    SQL
  end


end


# CREATE TABLE questions (
#   id INTEGER PRIMARY KEY,
#   title STRING,
#   body STRING,
#   author_id INTEGER,
#
#   FOREIGN KEY (author_id) REFERENCES users(id)
# );
#
# INSERT INTO
#   questions (title, body, author_id)
# VALUES
#   ("Halp", "I am stupid how do i fix this", 2);
