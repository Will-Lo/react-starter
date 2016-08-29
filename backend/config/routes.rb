Rails.application.routes.draw do  

  resources :students

  # all routes listed for react-starter
  
  get '/get_students' => 'students#get'
  post '/create_student' => 'students#create'
  post '/edit_student' => 'students#edit'
  delete '/remove_student' => 'students#remove'

end
