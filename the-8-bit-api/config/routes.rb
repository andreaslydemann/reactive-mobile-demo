Rails.application.routes.draw do
  post 'game_session/start'
  get 'game_session/green_bugs'
  post 'game_session/submit_score'
  get 'game_session/score_board'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
