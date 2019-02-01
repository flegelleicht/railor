Rails.application.routes.draw do
  resources :posts
	root 'upload#show'
	post '/upload', to: 'upload#upload', as: :picture_upload
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
