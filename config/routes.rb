Rails.application.routes.draw do
  
  resources :recepciones_de_bien_de_consumo

  get 'static_pages/home'
  get 'static_pages/help'    
  
  get 'recepciones_de_bien_de_consumo/new_bienes/:id' => 'recepciones_de_bien_de_consumo#new_bienes', as: 'agregar_bienes_recepciones_de_bien_de_consumo'

  put 'recepciones_de_bien_de_consumo/save_bienes/:id(.:format)', 
                                        :to => 'recepciones_de_bien_de_consumo#save_bienes',
                                        :as => 'save_bienes_recepciones_de_bien_de_consumo'


  post 'recepciones_de_bien_de_consumo/obtener_nombre_de_bien_de_consumo', 
                                        :to => 'recepciones_de_bien_de_consumo#obtener_nombre_de_bien_de_consumo',
                                        :as => 'obtener_nombre_bien_de_consumo_recepciones_de_bien_de_consumo'  

  delete 'recepciones_de_bien_de_consumo/eliminar_bien_de_recepcion/:id' => 'recepciones_de_bien_de_consumo#eliminar_bien_de_recepcion', 
                                        as: 'eliminar_bienes_de_recepcion_recepciones_de_bien_de_consumo'
                                        
  

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  match '/signup',  to: 'users#new',            via: 'get'

  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  root  'static_pages#home'  

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
