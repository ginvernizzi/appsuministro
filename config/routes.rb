Rails.application.routes.draw do
  
  resources :recepciones_de_bien_de_consumo_en_stock, only: [:index , :show]  
  resources :recepciones_de_bien_de_consumo_consumidas, only: [:index , :show] 
  resources :depositos
  resources :items_stock , only: [:index ]
  
  post 'recepciones_de_bienes_de_consumo_en_stock/:recepcion_de_bien_de_consumo_id/items_stock/imprimir_formulario/',  
                                                            to: 'items_stock#imprimir_formulario',
                                                            as: 'imprimir_items_stock_recepciones_de_bien_de_consumo_en_stock'

  post 'recepciones_de_bienes_de_consumo_consumidas/:consumo_directo_id/consumos_directo/imprimir_formulario/',  
                                                            to: 'consumos_directo#imprimir_formulario',
                                                            as: 'imprimir_consumos_directo_recepciones_de_bien_de_consumo_consumidas'


  get 'items_stock/:recepcion_id/ver_ingresar_a_stock/',  
                                                            to: 'items_stock#ver_ingresar_a_stock',
                                                            as: 'ver_ingresar_a_stock_items_stock'

  resources :areas do
    resources :depositos , only: [:new, :destroy]
  end

  resources :consumos_directo

  get 'consumos_directo/:recepcion_id/nuevo_consumo_directo_desde_recepcion/',  
                                                            to: 'consumos_directo#nuevo_consumo_directo_desde_recepcion',
                                                            as: 'nuevo_consumo_directo_desde_recepcion_consumos_directo'


  resources :obras_proyectos  

  get 'recepciones_de_bien_de_consumo_a_evaluar/:id/ver_rechazar' => 'recepciones_de_bien_de_consumo_a_evaluar#ver_rechazar', 
                                        as: 'ver_rechazar_recepciones_de_bien_de_consumo_a_evaluar'                                        

  post 'recepciones_de_bien_de_consumo_a_evaluar/:id/rechazar', :to => 'recepciones_de_bien_de_consumo_a_evaluar#rechazar', 
                                                                :as => 'rechazar_recepciones_de_bien_de_consumo_a_evaluar'

  resources :recepciones_de_bien_de_consumo_a_evaluar, only: [:index , :show] do 
    resources :items_stock , only: [:new, :create]
  end

  get 'static_pages/home' , :as => 'home'
  get 'static_pages/help'    
  
  resources :recepciones_de_bien_de_consumo do
      resources :bienes_de_consumo_de_recepcion , only: [:index, :new, :create, :destroy]
  end

  get 'recepciones_de_bien_de_consumo/enviar_a_evaluar/:id', 
                                        :to => 'recepciones_de_bien_de_consumo#enviar_a_evaluar',
                                        :as => 'enviar_a_evaluar_recepciones_de_bien_de_consumo'


  post 'bienes_de_consumo_de_recepcion/obtener_nombre_de_bien_de_consumo', 
                                        :to => 'bienes_de_consumo_de_recepcion#obtener_nombre_de_bien_de_consumo',
                                        :as => 'obtener_nombre_bien_de_consumo_bienes_de_consumo_de_recepcion'  

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
