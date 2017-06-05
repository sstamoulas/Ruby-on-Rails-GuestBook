Rails.application.routes.draw do
  resources :people
  get 'entries/sign_in' => 'entries#sign_in'
  post 'entries/sign_in' => 'entries#sign_in'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
