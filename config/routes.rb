Rails.application.routes.draw do
  apipie
  get 'welcome/index'
  root 'welcome#index'

  post 'texts/expand_pointer'
  match '/questions' => "questions#options", via: :options
  match '/texts' => "texts#options", via: :options
  resources :questions
  resources :texts, only:[:show]
end
