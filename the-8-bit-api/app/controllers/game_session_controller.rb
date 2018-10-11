class GameSessionController < ApplicationController
  SCORE_DIFFICULTY_INCREMENTS=10

  def start
    name = params.fetch(:name).downcase
    user = User.find_or_create_by(name: name)

    response = { name: user.name, highScore: user.high_score}
    render json: response 
  end

  def green_bugs
    score = params.fetch(:score).to_i
    
    response = {
      greenBugs: 0
    }
    
    score_remainder = score % SCORE_DIFFICULTY_INCREMENTS
    
    # Add 1 green bug with an increasing probability depending on their score.
    response[:greenBugs] += (score / SCORE_DIFFICULTY_INCREMENTS).to_i

    # Add 1 green bug for every `SCORE_DIFFICULTY_INCREMENTS` points they have.
    response[:greenBugs] += 1 if rand(SCORE_DIFFICULTY_INCREMENTS) < score_remainder
    
    render json: response
  end

  def score_board
    limit = params.fetch(:limit, 10)
    response = User.order(high_score: :desc).limit(limit).map do |user|
      { name: user.name, highScore: user.high_score }
    end
    render json: response
  end

  def submit_score
    name = params.fetch(:name).downcase
    score = params.fetch(:score).to_i

    user = User.find_by_name(name)
    raise "No user called #{name} exists" if user.nil?
    
    if score > user.high_score
      user.update(high_score: score)
    end
    
    response = { highScore: user.high_score }
    render json: response
  end
end
