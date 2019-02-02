Rails.application.routes.draw do
  resources :posts
	root 'upload#show'
	post '/upload', to: 'upload#upload', as: :picture_upload
	get '/uploads', to: 'upload#index', as: :uploads
	get '/thumbor/:location', to: 'thumbor#load', as: :thumbor
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
