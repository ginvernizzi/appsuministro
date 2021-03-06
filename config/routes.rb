Rails.application.routes.draw do

  resources :ingreso_manual_a_stocks
  get 'reemplazo_clase/index'

  resources :registro_ingreso_manual , only: [:index] do
    collection do
      get 'traer_ingresos_manuales'
    end
  end

  resources :reemplazo_bdc , only: [:index, :new] do
    collection do
      get 'autocomplete_bien_de_consumo_dado_de_baja_nombre_by_clase'
      get 'autocomplete_bien_de_consumo_dado_de_alta_nombre_by_clase'
      post 'traer_item_dado_de_baja_por_nombre'
      post 'traer_item_dado_de_alta_por_nombre'
      post 'traer_bien_dado_de_baja_por_clase'
      post 'traer_bien_dado_de_alta_por_clase'
      post 'crear_reemplazo_de_bien_manual'
    end
  end

  resources :reemplazo_clase , only: [:index, :new] do
    collection do
      get 'autocomplete_clase_dada_de_baja_nombre_por_partida_parcial'
      get 'autocomplete_clase_dada_de_alta_nombre_por_partida_parcial'
      post 'traer_clase_dada_de_baja_por_nombre'
      post 'traer_clase_dada_de_alta_por_nombre'
      post 'traer_clase_dada_de_baja_por_partida_parcial'
      post 'traer_clase_dada_de_alta_por_partida_parcial'
      post 'crear_reemplazo_de_clase_manual'
    end
  end

  resources :foo

  resources :clases do
    collection do
      get 'autocomplete_clase_nombre_traer_todas_las_clases'
      get 'autocomplete_clase_nombre'
      get 'traer_clase_por_id'
      get 'traer_todas_las_clases'
      get 'traer_partidas_parciales_con_codigo_de_clase_existente'
      get 'traer_partidas_parciales_con_nombre_de_clase_similar'
      get 'ver_clases_dadas_de_baja'
      post 'imprimir_listado_de_clases'
    end
  end

  get 'clases/:clase_id/traer_vista_dar_de_baja_y_reemplazar/',
                                to: 'clases#traer_vista_dar_de_baja_y_reemplazar',
                                as: 'traer_vista_dar_de_baja_y_reemplazar_clases'

  put 'clases/:clase_id/dar_de_baja_y_reemplazar/',
                                to: 'clases#dar_de_baja_y_reemplazar',
                                as: 'dar_de_baja_y_reemplazar_clases'

  resources :partidas_parciales do
    collection do
      get 'autocomplete_partida_parcial_nombre'
    end
  end

  resources :partidas_principales

  resources :incisos

  resources :reportes_a_fecha do
    member do
      post 'imprimir_formulario'
    end
    collection do
      get 'traer_items_stock'
    end
  end

  resources :bienes_de_consumo do
    collection do
      get 'autocomplete_bien_de_consumo_nombre_traer_todos_los_items'
      get 'traer_items_de_la_clase'
      get 'traer_item_por_id'
      get 'traer_todos_los_items'
      get 'traer_vista_de_categoria'
      get 'traer_clases_con_codigo_de_bien_existente'
      get 'traer_clases_con_nombre_de_bien_de_consumo_similar'
      get 'ver_items_dados_de_baja'
      get 'existen_stocks_minimos_superados'
      post 'imprimir_listado_de_items'
      post 'traer_costo_de_bien_de_consumo'
    end

    # resources :areas  do
    #   resources :items_stock do
    #     #post 'imprimir_formulario_stock_total_por_bien_y_area'
    #   end
    #end
  end


  get 'bienes_de_consumo/:bien_de_consumo_id/traer_vista_dar_de_baja_y_reemplazar/',
                                to: 'bienes_de_consumo#traer_vista_dar_de_baja_y_reemplazar',
                                as: 'traer_vista_dar_de_baja_y_reemplazar_bienes_de_consumo'

  put 'bienes_de_consumo/:bien_de_consumo_id/dar_de_baja_y_reemplazar_bienes_de_consumo/',
                                to: 'bienes_de_consumo#dar_de_baja_y_reemplazar_bienes_de_consumo',
                                as: 'dar_de_baja_y_reemplazar_bienes_de_consumo'

  resources :personas

  resources :recepciones_de_bien_de_consumo do
      collection do
        get 'ver_rechazadas'
        get 'traer_documentos_con_numero_existente'
      end
      resources :bienes_de_consumo_de_recepcion , only: [:index, :new, :create, :destroy, :show]
  end

  get 'recepciones_de_bien_de_consumo/enviar_a_evaluar/:id',
                                        :to => 'recepciones_de_bien_de_consumo#enviar_a_evaluar',
                                        :as => 'enviar_a_evaluar_recepciones_de_bien_de_consumo'


  post 'bienes_de_consumo_de_recepcion/obtener_nombre_de_bien_de_consumo',
                                        :to => 'bienes_de_consumo_de_recepcion#obtener_nombre_de_bien_de_consumo',
                                        :as => 'obtener_nombre_bien_de_consumo_bienes_de_consumo_de_recepcion'

  post 'bienes_de_consumo_de_recepcion/obtener_codigo_de_bien_de_consumo',
                                        :to => 'bienes_de_consumo_de_recepcion#obtener_codigo_de_bien_de_consumo',
                                        :as => 'obtener_codigo_bien_de_consumo_bienes_de_consumo_de_recepcion'

  delete 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/eliminar_bien_de_recepcion/:bien_de_consumo_id' => 'recepciones_de_bien_de_consumo#eliminar_bien_de_recepcion',
                                        as: 'eliminar_bienes_de_recepcion_recepciones_de_bien_de_consumo'

  post 'recepciones_de_bien_de_consumo/pegar_campo_descripcion_provisoria', :to => 'recepciones_de_bien_de_consumo#pegar_campo_descripcion_provisoria'

  delete 'recepciones_de_bien_de_consumo/:recepcion_de_bien_de_consumo_id/eliminar_documento_secundario/:documento_secundario_id' => 'recepciones_de_bien_de_consumo#eliminar_documento_secundario',
                                        as: 'eliminar_documento_secundario_recepciones_de_bien_de_consumo'

  resources :transferencias do
    collection do
      get 'nueva_transferencia'
      post 'crear_transferencia'
    end
  end

  get 'transferencias/:recepcion_id/nueva_transferencia_desde_recepcion/',
                                                            to: 'transferencias#nueva_transferencia_desde_recepcion',
                                                            as: 'nueva_transferencia_desde_recepcion_transferencias'

  resources :recepciones_de_bien_de_consumo_en_stock, only: [:index , :show]  do
      get 'imprimir_detalle_recepcion'
      collection do
        get 'autocomplete_documento_principal_nombre'
        get 'traer_recepciones_por_doc_principal'
        get 'ver_recepciones_finalizadas_por_bien_de_consumo_y_fecha'
        get 'traer_recepciones_por_bien_y_fecha'
        get 'ver_recepciones_finalizadas_por_fecha'
        get 'traer_recepciones_finalizadas_por_fecha'
        get 'ver_recepciones_finalizadas_por_fecha_por_recepcion'
        get 'traer_recepciones_finalizadas_por_fecha_por_recepcion'
      end
  end

  get 'recepciones_de_bien_de_consumo_en_stock/documento_principal/:documento_principal/imprimir_formulario_recepciones_por_documento_principal/',
                                                            to: 'recepciones_de_bien_de_consumo_en_stock#imprimir_formulario_recepciones_por_documento_principal',
                                                            as: 'imprimir_formulario_recepciones_por_documento_principal'


  post 'recepciones_de_bien_de_consumo_en_stock/bien_de_consumo/:bien_de_consumo_id/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_recepciones_finalizadas_por_bien_y_fecha/',
                                                            to: 'recepciones_de_bien_de_consumo_en_stock#imprimir_formulario_recepciones_finalizadas_por_bien_y_fecha',
                                                            as: 'imprimir_formulario_recepciones_finalizadas_por_bien_y_fecha'

  post 'recepciones_de_bien_de_consumo_en_stock/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_recepciones_finalizadas_por_fecha/',
                                                            to: 'recepciones_de_bien_de_consumo_en_stock#imprimir_formulario_recepciones_finalizadas_por_fecha',
                                                            as: 'imprimir_formulario_recepciones_finalizadas_por_fecha'

  get 'recepciones_de_bien_de_consumo_en_stock/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_recepciones_finalizadas_por_fecha_por_recepcion/',
                                                            to: 'recepciones_de_bien_de_consumo_en_stock#imprimir_formulario_recepciones_finalizadas_por_fecha_por_recepcion',
                                                            as: 'imprimir_formulario_recepciones_finalizadas_por_fecha_por_recepcion'


  resources :recepciones_de_bien_de_consumo_consumidas, only: [:index , :show]
  resources :depositos
  resources :items_stock , only: [:index, :new ] do
    collection do
      post'ingresar_bienes_a_stock_manualmente'
       get 'guardar_stock_a_fecha'
       get 'traer_todos_los_items_stock'
       get 'traer_items_stock_por_bien_y_area'
       get 'traer_items_stock_por_fecha_bien_y_area_suministro'
       get 'traer_items_stock_minimo_superado'
       get 'traer_items_stock_minimo_superado_por_bien_y_area'
       get 'traer_datos_de_clase_y_bien'
       get 'ver_stock_minimo_superado'
       get 'ver_stock_con_subtotal_por_pp'
       get 'autocomplete_bien_de_consumo_nombre'
       get 'autocomplete_area_nombre'
       post 'imprimir_formulario_stock_total_todos_los_bienes'
      post 'traer_cantidad_en_stock_en_suministro'
      post 'imprimir_formulario_stock_faltante'
     end
  end



  post 'items_stock/area_id/(:area_id)/bien_id/(:bien_id)/partida_parcial/(:partida_parcial)/fecha_inicio/(:fecha_inicio)/fecha_fin/(:fecha_fin)/imprimir_formulario_stock_total_por_bien_y_area/',
                                                            to: 'items_stock#imprimir_formulario_stock_total_por_bien_y_area',
                                                            as: 'imprimir_formulario_stock_total_por_bien_y_area'

  post 'items_stock/area_id/(:area_id)/bien_id/(:bien_id)/imprimir_formulario_stock_faltante/',
                                                            to: 'items_stock#imprimir_formulario_stock_faltante',
                                                            as: 'imprimir_formulario_stock_faltante'

  post 'items_stock/fecha_inicio/(:fecha_inicio)/fecha_fin/(:fecha_fin)/imprimir_formulario_stock_total_con_subtotal_por_pp/',
                                                                                                                      to: 'items_stock#imprimir_formulario_stock_total_con_subtotal_por_pp',
                                                                                                                      as: 'imprimir_formulario_stock_total_con_subtotal_por_pp'


  post 'recepciones_de_bienes_de_consumo_en_stock/:recepcion_de_bien_de_consumo_id/items_stock/imprimir_formulario/',
                                                            to: 'items_stock#imprimir_formulario',
                                                            as: 'imprimir_items_stock_recepciones_de_bien_de_consumo_en_stock'


  post 'transferencias/imprimir_formulario/:transferencia_id',  to: 'transferencias#imprimir_formulario',
                                                                    as: 'imprimir_formulario_transferencias'


  get 'items_stock/:recepcion_id/ver_ingresar_a_stock/',  to: 'items_stock#ver_ingresar_a_stock',
                                                          as: 'ver_ingresar_a_stock_items_stock'

  resources :areas do
    resources :depositos , only: [:new, :destroy]
  end


  resources :consumos_directo do
    collection do
      post 'obtener_item_para_agregar_a_recepcion_by_id'
      get 'autocomplete_obra_proyecto_descripcion'
      get 'nuevo_consumo'
      get 'ver_dados_de_baja'
      post 'crear_consumo'
      post 'obtener_nombre_de_bien_de_consumo'
      post 'obtener_nombre_y_stock_de_bien_de_consumo_por_id_y_deposito'
      post 'obtener_responsable_de_area'
      get 'ver_consumos_por_codigo_destino_fecha'
      get 'ver_consumos_y_transferencias_por_nombre_y_fecha'
      get 'traer_consumos_y_transferencias_por_nombre_y_fecha'
      get 'traer_consumos_por_codigo_destino_y_fecha'
      get 'traer_consumos_por_obra_proyecto_destino_y_fecha'
      get 'ver_consumos_por_obra_proyecto_y_fecha'
      get 'traer_consumos_por_partida_parcial_destino_y_fecha'
      get 'ver_consumos_por_partida_parcial_destino_fecha'
      get 'ver_consumos_por_fecha_destino_y_clase'
      get 'traer_consumos_por_fecha_destino_y_clase'
    end
  end

  get 'consumos_directo/:recepcion_id/nuevo_consumo_directo_desde_recepcion/',
                                                            to: 'consumos_directo#nuevo_consumo_directo_desde_recepcion',
                                                            as: 'nuevo_consumo_directo_desde_recepcion_consumos_directo'

  post 'consumos_directo/imprimir_formulario/:consumo_directo_id',  to: 'consumos_directo#imprimir_formulario',
                                                                    as: 'imprimir_formulario_consumos_directo'

  post 'consumos_directo/bien_de_consumo/(:bien_id)/area/(:area_id)/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_consumos_por_codigo_destino_y_fecha/',
                                                            to: 'consumos_directo#imprimir_formulario_consumos_por_codigo_destino_y_fecha',
                                                            as: 'imprimir_formulario_consumos_por_codigo_destino_y_fecha'

  post 'consumos_directo/obra_proyecto/:obra_proyecto_id/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_consumos_por_obra_proyecto_y_fecha/',
                                                            to: 'consumos_directo#imprimir_formulario_consumos_por_obra_proyecto_y_fecha',
                                                            as: 'imprimir_formulario_consumos_por_obra_proyecto_y_fecha'

  post 'consumos_directo/codigo_partida_parcial/(:codigo_partida_parcial)/area/(:area_id)/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_consumos_por_partida_parcial_destino_y_fecha/',
                                                            to: 'consumos_directo#imprimir_formulario_consumos_por_partida_parcial_destino_y_fecha',
                                                            as: 'imprimir_formulario_consumos_por_partida_parcial_destino_y_fecha'


  post 'consumos_directo/bien_de_consumo/:bien_id/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_consumos_y_transferencias_por_nombre_y_fecha/',
                                                            to: 'consumos_directo#imprimir_formulario_consumos_y_transferencias_por_nombre_y_fecha',
                                                            as: 'imprimir_formulario_consumos_y_transferencias_por_nombre_y_fecha'

                                                            get ':controller(/:action(/:id))'

  post 'consumos_directo/area_id/:area_id/clase/(:clase)/fecha_inicio/:fecha_inicio/fecha_fin/:fecha_fin/imprimir_formulario_consumos_por_fecha_destino_y_clase/',
                                                            to: 'consumos_directo#imprimir_formulario_consumos_por_fecha_destino_y_clase',
                                                            as: 'imprimir_formulario_consumos_por_fecha_destino_y_clase'

  resources :obras_proyectos

  resources :recepciones_de_bien_de_consumo_a_evaluar, only: [:index , :show] do
    resources :items_stock , only: [:new, :create]
  end

  get 'recepciones_de_bien_de_consumo_a_evaluar/ver_rechazar/:id' => 'recepciones_de_bien_de_consumo_a_evaluar#ver_rechazar',
                                        as: 'ver_rechazar_recepciones_de_bien_de_consumo_a_evaluar'

  post 'recepciones_de_bien_de_consumo_a_evaluar/:id/rechazar', :to => 'recepciones_de_bien_de_consumo_a_evaluar#rechazar',
                                                                :as => 'rechazar_recepciones_de_bien_de_consumo_a_evaluar'


  get 'static_pages/home' , :as => 'home'
  get 'static_pages/help'


  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  match '/signup',  to: 'users#new',            via: 'get'

  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  #esto lo hice para que machee la ruta llamandola desde una funcion en AJAX
  match '/consumos_directo/imprimir_formulario', to: 'consumos_directo#imprimir_formulario', via: :post

  root  'static_pages#home'

end
