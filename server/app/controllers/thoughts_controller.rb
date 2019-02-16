class ThoughtsController < ApplicationController
  def create
    text = params.require(:text)
    Thought.create(text: text, user: current_user)
    render json: {}, status: 201
  end
  
  def index
    filter = params[:filter]
    limit = params[:limit].try(:to_i) || 10
    
    if filter.present?
      thoughts = Thought.search_for(filter).order(updated_at: :desc).limit(limit)
    else
      thoughts = Thought.order(updated_at: :desc).limit(limit)
    end
    
    render json: thoughts.map(&:api_response_json)
  end
end