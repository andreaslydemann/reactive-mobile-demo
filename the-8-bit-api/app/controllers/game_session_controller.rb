class GameSessionController < ApplicationController
  SCORE_DIFFICULTY_INCREMENTS=15

  # TODO: This should be in its own controller
  def user
    name = params.fetch(:name).downcase.chomp
    user = User.find_or_create_by(name: name)

    response = { name: user.name, high_score: user.high_score}
    render json: response 
  end

  def green_bugs
    score = params.fetch(:score).to_i
    
    response = {
      green_bugs: 0
    }
    
    score_remainder = score % SCORE_DIFFICULTY_INCREMENTS
    
    # Add 1 green bug with an increasing probability depending on their score.
    response[:green_bugs] += (score / SCORE_DIFFICULTY_INCREMENTS).to_i

    # Add 1 green bug for every `SCORE_DIFFICULTY_INCREMENTS` points they have.
    response[:green_bugs] += 1 if rand(SCORE_DIFFICULTY_INCREMENTS) < score_remainder
    
    render json: response
  end

  def score_board
    limit = params.fetch(:limit, 10)
    response = User.order(high_score: :desc).limit(limit).map do |user|
      { name: user.name, score: user.high_score }
    end
    render json: response
  end

  def submit_score
    name = params.fetch(:name).downcase.chomp
    score = params.fetch(:score).to_i

    user = User.find_by_name(name)
    raise "No user called #{name} exists" if user.nil?
    
    if score > user.high_score
      user.update(high_score: score)
    end
    
    response = { name: name, score: user.high_score }
    render json: response
  end
end
