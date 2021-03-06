Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'scout#index'

  get '/ping' => 'scout#ping'

  scope :scout do
    get '/pit' => 'scout#pit_scout', as: :pit_scout
    post '/pit/submit' => 'scout#submit_pit_scout'
    get '/match' => 'scout#match_scout', as: :match_scout
    post '/match/submit' => 'scout#submit_match_scout'
  end

  scope :teams do
    get '/check_in' => 'teams#check_in', as: :check_in
    post '/check_in/active' => 'teams#check_in_active', as: :check_in_active
    post '/check_in/inactive' => 'teams#check_in_inactive', as: :check_in_inactive
    post '/import_pit_data' => 'teams#import_pit_data', as: :team_import_pits
    post '/import_match_data' => 'teams#import_match_data', as: :team_import_matches
    get '/export_pit_data' => 'teams#export_pit_data', as: :pit_data_download
    get '/export_match_data' => 'teams#export_match_data', as: :match_data_download
  end

  namespace :admin do
    root 'panel#index'
    get '/tba_imports' => 'panel#tba_imports', as: :tba_imports
    post '/tba_imports/events' => 'import#import_events', as: :tba_import_events
    post '/tba_imports/events/update' => 'import#update_events', as: :tba_update_events
    post '/tba_imports/events/reset' => 'import#reset_events', as: :tba_reset_events
    delete '/tba_imports/events/delete' => 'import#delete_events', as: :tba_delete_events
  end

  scope :team_registrations do
    post '/' => 'team_registrations#create', as: :team_registrations
    delete '/' => 'team_registrations#destroy'
    patch '/' => 'team_registrations#update'
    get '/confirm/:id' => 'team_registrations#confirm', as: :team_registrations_confirm
    get '/deny/:id' => 'team_registrations#deny', as: :team_registrations_deny
    get '/remove/:id' => 'team_registrations#remove', as: :team_registrations_remove
    get '/promote/:id' => 'team_registrations#promote', as: :team_registrations_promote
    get '/demote/:id' => 'team_registrations#demote', as: :team_registrations_demote
    get '/check_in/:id' => 'team_registrations#check_in', as: :team_registrations_check_in
    get '/check_out/:id' => 'team_registrations#check_out', as: :team_registrations_check_out
  end

  resources :teams
  resources :schematics
  resources :events

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
