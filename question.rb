require_relative 'questiondatabase'
require_relative 'user'

class Question 
  attr_accessor :id, :title, :body, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id:id)
      SELECT 
        *
      FROM
        questions
      WHERE
        id = :id
    SQL
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id:author_id)
        SELECT 
            *
        FROM
            questions
        WHERE
            user_id = :author_id
    SQL
    Question.new(question.first)
  end

  def author
   User.find_by_id(user_id)
  end

end