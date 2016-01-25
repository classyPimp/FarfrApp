Rails.application.routes.draw do
  
  root 'sessions#new'

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  match '/contract_attachments/documents/:id1/:id2/:id3/:style/:filename.:extension' => 'contract_attachments#download', via: ['get','post']
  match '/attachments/attachments/:id1/:id2/:id3/:style/:filename.:extension' => 'attachments#download', via: ['get','post']

  resources :users, path_names: {new: 'sign_up'}

  resources :users do
    resource :contract_approver
    resources :user_notifications, only: [:update]
    put 'user_notifications' => 'user_notifications#update', as: :user_notifications_mass_update

  end

  resources :comments
  resources :contragents, only: [:create, :new, :show]

  resources :contracts do
    resources :contract_comments
    resources :contract_attachments
  end

  resources :contract_kept_at_confirmations, only: [:update]
  put 'contract_kept_at_confirmations' => 'contract_kept_at_confirmation#update', as: :contract_kept_at_confirmations_mass_update

  resources :assignments do
    resources :assignees
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
