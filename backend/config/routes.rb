Rails.application.routes.draw do  

  resources :pages

  # all routes listed for react-starter
  
  get '/get_pages' => 'pages#get'
  post '/create_page' => 'pages#create'
  post '/edit_page' => 'pages#edit'
  delete '/remove_page' => 'pages#remove'
  delete '/remove_multiple_portlets' => 'pages#remove_multiple_portlets' # see controller for details

end
