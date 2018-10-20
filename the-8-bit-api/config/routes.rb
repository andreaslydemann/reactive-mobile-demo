Rails.application.routes.draw do
  get 'game_session/user'
  get 'game_session/green_bugs'
  post 'game_session/submit_score'
  get 'game_session/score_board'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
