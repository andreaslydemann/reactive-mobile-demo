class UsersController < ApplicationController
  skip_before_action :authenticate_request
  
  include BCrypt
  
  def create
    username = params.require(:username).downcase
    password = params.require(:password)

    existing = User.find_by_username(username) 
    return render json: { error: 'User already exists' }, status: 400 if existing.present?
    
    salt = SecureRandom.uuid
    user = User.create!(username: username, salt: salt, password: salt + password)
    token = AuthenticateUser.call(username, password, user.salt).result
    render json: { auth_token: token, user_id: user.id }, status: 201
  end
  
  def authenticate
    username = params.require(:username).downcase
    password = params.require(:password)
    
    user = User.find_by_username(username)
    return render json: { error: 'User does not exist' }, status: :unauthorized if user.nil?
    
    command = AuthenticateUser.call(username, password, user.salt)

    if command.success?
      render json: { auth_token: command.result, user_id: user.id }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end