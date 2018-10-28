Rails.application.routes.draw do
  apipie
  get 'welcome/index'
  root 'welcome#index'

  post 'texts/expand_pointer'
  match '/questions' => "questions#options", via: :options
  resources :questions
  resources :texts, only:[:show]
end
