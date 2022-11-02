require_relative 'questiondatabase'
class User 
  attr_accessor :id, :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id:id)
      SELECT 
        *
      FROM
        users
      WHERE
        id = :id
    SQL
    User.new(data.first)
    
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname:fname, lname:lname)
      SELECT 
        *
      FROM
        users
      WHERE
        fname = :fname
        AND
        lname = :lname
    SQL
    User.new(data.first)
  end 


end
