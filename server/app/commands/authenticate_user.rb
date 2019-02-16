class AuthenticateUser
  prepend SimpleCommand

  def initialize(username, password, salt)
    @username = username
    @password = password
    @salt = salt
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :username, :password, :salt

  def user
    user = User.find_by_username(username)
    return user if user && user.authenticate(salt + password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end