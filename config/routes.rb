Rails.application.routes.draw do

  get 'recepciones_de_bien_de_consumo_a_evaluar/:id/ver_rechazar' => 'recepciones_de_bien_de_consumo_a_evaluar#ver_rechazar', 
                                        as: 'ver_rechazar_recepciones_de_bien_de_consumo_a_evaluar'                                        

  post 'recepciones_de_bien_de_consumo_a_evaluar/:id/rechazar', :to => 'recepciones_de_bien_de_consumo_a_evaluar#rechazar', 
                                                                :as => 'rechazar_recepciones_de_bien_de_consumo_a_evaluar'

  resources :recepciones_de_bien_de_consumo_a_evaluar, only: [:index , :show]

  get 'static_pages/home' , :as => 'home'
  get 'static_pages/help'    
  
  resources :recepciones_de_bien_de_consumo

  get 'recepciones_de_bien_de_consumo/enviar_a_evaluar/:id', 
                                        :to => 'recepciones_de_bien_de_consumo#enviar_a_evaluar',
                                        :as => 'enviar_a_evaluar_recepciones_de_bien_de_consumo'

  get 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/new_bienes/' => 'recepciones_de_bien_de_consumo#new_bienes', 
                                        as: 'agregar_bienes_recepciones_de_bien_de_consumo'

  put 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/save_bienes/', 
                                        :to => 'recepciones_de_bien_de_consumo#save_bienes',
                                        :as => 'save_bienes_recepciones_de_bien_de_consumo'


  post 'recepciones_de_bien_de_consumo/obtener_nombre_de_bien_de_consumo', 
                                        :to => 'recepciones_de_bien_de_consumo#obtener_nombre_de_bien_de_consumo',
                                        :as => 'obtener_nombre_bien_de_consumo_recepciones_de_bien_de_consumo'  

  delete 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/eliminar_bien_de_recepcion/:bien_de_consumo_id' => 'recepciones_de_bien_de_consumo#eliminar_bien_de_recepcion', 
                                        as: 'eliminar_bienes_de_recepcion_recepciones_de_bien_de_consumo'
                                        
  post 'recepciones_de_bien_de_consumo/pegar_campo_descripcion_provisoria', :to => 'recepciones_de_bien_de_consumo#pegar_campo_descripcion_provisoria'  

  delete 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/eliminar_documento_secundario/:documento_secundario_id' => 'recepciones_de_bien_de_consumo#eliminar_documento_secundario', 
                                        as: 'eliminar_documento_secundario_recepciones_de_bien_de_consumo'

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
