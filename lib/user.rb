class User
  attr_reader :id, :username, :password
  def initialize(user)
    @id       = user['id']
    @username = user['username']
    @password = user['password']
  end

  def self.create(username:, password:)
    res = DatabaseConnection.query("
      insert into
        users
          (username,password)
        values
          ('#{username}' ,'#{password}')
        returning
          id,username,password
      ;").first
    User.new(res)
  end

  def self.find(id:)
    res = DatabaseConnection.query("
      select
        id,username,password
      from
        users
      where
        id = #{id}
      ;").first

    User.new(res)
  end
end
