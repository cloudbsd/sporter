Sporter::Application.routes.draw do
  root 'users#index'

  devise_for :users

  resources :users, except: [:destroy] do
    member do
      get :transactions
    end
    collection do
      get :managements
      post :create_member
    end
  end

# resources :debits

  resources :groups do
    resources :activities, except: [:index] do
      resources :fee_items, only: [:new, :edit, :create, :update, :destroy]
      resources :participants, only: [:new, :edit, :create, :update, :destroy]
    end
    resources :fees, only: [:new, :edit, :create, :update, :destroy]
    resources :card_types, except: [:index, :show]
    member do
      get :activities
      get :members
      get :transactions
      get :fees
      get :card_types
    end
    collection do
      post :cities
      post :districts
    end
  end

# resources :activities, only: [] do
#   resources :fee_items, only: [:new, :create, :destroy]
# end

  resources :transactions


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
