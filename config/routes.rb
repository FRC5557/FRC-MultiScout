Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'scout#index'

  scope :team_registrations do
    post '/' => 'team_registrations#create', as: :team_registrations
    delete '/' => 'team_registrations#destroy'
    patch '/' => 'team_registrations#update'
    get '/confirm/:id' => 'team_registrations#confirm', as: :team_registrations_confirm
    get '/deny/:id' => 'team_registrations#deny', as: :team_registrations_deny
    get '/remove/:id' => 'team_registrations#remove', as: :team_registrations_remove
    get '/promote/:id' => 'team_registrations#promote', as: :team_registrations_promote
    get '/demote/:id' => 'team_registrations#demote', as: :team_registrations_demote
  end

  resources :teams
  resources :schematics

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
