require 'bcrypt'

class User
  attr_reader :id, :email_address, :username
  def initialize(user)
    @id = user['id']
    @email_address = user['email_address']
    @username = user['username']
  end

  def self.create(email_address:, username:, password:)
    encrypted_password = BCrypt::Password.create(password)
    res = DatabaseConnection.query("
      insert into
        users
          ( email_address, username, password)
        values
          ('#{email_address}','#{username}' ,'#{encrypted_password}')
        returning
          id, email_address, username, password
      ;").first
    User.new(res)
  end

  def self.find(id:)
    return nil unless id

    res = DatabaseConnection.query("
      select
        id ,email_address ,username
      from
        users
      where
        id = #{id}
      ;").first

    User.new(res)
  end

  def self.login(email_address:, password:)
    user = DatabaseConnection.query("
      select
        id ,email_address ,username ,password
      from
        users
      where
        email_address = '#{email_address}'
      ").first

    return nil unless user
    return nil unless BCrypt::Password.new(user['password']) == password

    User.new(user)
  end
end
