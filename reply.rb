require_relative 'questiondatabase'
require_relative 'user'
require_relative 'question'

class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @body = options['body']
    @user_id = options['user_id']
    @parent_reply_id = options['parent_reply_id']
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id:id)
      SELECT 
        *
      FROM
        replies
      WHERE
        id = :id
    SQL
    Reply.new(reply.first)
    
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id:user_id)
    SELECT 
      *
    FROM
      replies
    WHERE
      user_id = :user_id
    SQL
    Reply.new(reply.first)
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id:question_id)
    SELECT 
      *
    FROM
      replies
    WHERE
      question_id = :question_id
    SQL
    Reply.new(reply.first)
  end


  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.parent_reply_id, self.user_id, self.body)
      INSERT INTO
        replies (question_id, parent_reply_id, user_id, body)
      VALUES
        (?, ?, ?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_reply_id(@id)
  end


  def self.find_by_parent_reply_id(parent_reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id:parent_reply_id)
    SELECT 
      *
    FROM
      replies
    WHERE
      id = :parent_reply_id
    SQL
    Reply.new(reply.first)
  end


end