Impulsideas::Application.routes.draw do

  get "contact_form/new"
  get "contact_form/create"
  resources :items
  resources :contact_form, only: :create

  get "about/faq"
  mount RedactorRails::Engine => '/redactor_rails'
  get "about/index"
  get "about/main"
  get "about/terms"
  get "about/landing"
  get 'about', to: 'about#index', as: 'about'

  resources :payment_notifications
  post 'ipn_notifications/:contribution_id', to: 'payment_notifications#create', as: 'ipn_notifications'

  resources :projects do
    resources :contributions
  end

  devise_for :users, controllers: { :omniauth_callbacks => "users/omniauth_callbacks",
                                    :registrations => "registrations"  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'about#main'

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
