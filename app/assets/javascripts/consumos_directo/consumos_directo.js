$(document).on("ready page:load", function() {  

  //mascara entero, 6
  $('#cantidad_a_consumir').inputmask('999999', { clearMaskOnLostFocus: true, placeholder: ' ' })    
  $("#codigo").inputmask("9.9.9.99999.9999", { clearMaskOnLostFocus: true })   
  
  var currentDate = new Date();
  $('#consumo_directo_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });

  $("#consumo_directo_fecha").datepicker("setDate", currentDate);

  $('#fecha_inicio').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });

  $("#fecha_inicio").datepicker("setDate", currentDate);

  $('#fecha_fin').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });

  $("#fecha_fin").datepicker("setDate", currentDate);

  //$("#consumo_directo_area_id").change(function() { 
    //identificador_del_control = $("#consumo_directo_area_id").val(); 
    //traer_responsable(identificador_del_control)    
  //});

  //////////// AUTOCOMPLETAR VER CONSUMOS POR CODIGO Y DESTINO ///////////
  $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#bien_de_consumo_id").val(data.item.id);       
  });

  $('#area_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#area_id").val(data.item.id);       
  });

  $('#obra_proyecto_descripcion').on('railsAutocomplete.select', function(event, data){ 
    $("#obra_proyecto_id").val(data.item.id);         
  })

  ////////////////////////////////////////////////

  $("#area_origen_area_id").change(function() 
  {
    identificador_del_control = $("#area_origen_area_id").val();
    traer_responsable(identificador_del_control)    
  });

  function traer_responsable(id_del_control)
  {
    $.ajax({
      url: "/consumos_directo/obtener_responsable_de_area",
      dataType: "json",
      //contentType: "application/json", no va, si no envias un json!!!
      type: "post",
      data: { area_id: id_del_control },                
      success:function(data){                  
          $("#responsable").val(data.responsable)              
        },
        error: function (request, status, error) 
          { 
          //alert("Bien de consumo inexistente"); 
          }
      });
   } 

    $("#traer_bien_de_consumo_y_cantidad_stock").click(function() {  
    var cod = $("#codigo").val();          
    var depositoId = $("#consumo_directo_deposito_deposito_id").val();

    ObtenerBienDeConsumoYcantidadEnStock(cod, depositoId)
    });


  $("#agregar_bien_a_consumir").click(function() {
    var array_bienes = get_tabla_de_bienes() 
    var bien_encontrado = array_bienes.filter(function( obj ) { return obj.Codigo == $("#codigo").val(); })
    var deposito_encontrado = array_bienes.filter(function( obj ) { return obj.DepoId == $("#consumo_directo_deposito_deposito_id").val(); })
    if (bien_encontrado.length > 0 && deposito_encontrado.length > 0)
    { 

      alert("El Bien de consumo ya fue agregado")
     
      blanquear_campos()
      return ;
    }

    var bien_id = $("#bien_de_consumo_id").val();
    var cod = $("#codigo").val();    
    var nom = $("#consumo_directo_nombre").val();    
    var cant_stock = $("#cantidad_stock").val();
    var cant_consumir = $("#cantidad_a_consumir").val();
    var depo_id = $("#consumo_directo_deposito_deposito_id").val();
    var depo = $("#consumo_directo_deposito_deposito_id option:selected").text();

    if(cant_consumir)
    {
      if(cant_consumir == 0 || parseInt(cant_consumir) > parseInt(cant_stock) || cant_stock == 0)
      { alert("El stock es insufuciente para consumir.") }
      else
      {
        $('#bienes_table').append('<tr id='+bien_id+'> <td style="display:none;">'+bien_id+'</td> <td style="display:none;">'+depo_id+'</td> <td>'+cod+'</td> <td>'+nom+'</td> <td>'+depo+'</td><td>'+cant_stock+'</td><td>'+cant_consumir+'</td><td> Ud </td><td> <a href="javascript:void(0);" class="remCF">Eliminar</a> </td> </tr>'); 

        blanquear_campos()
      }
    }
    else
    { alert("Debe ingresar la cantidad a consumir.") }
  });


  $("#eliminar_todos_los_bienes").click(function() {
    //$('#bienes_table').empty();       
    $("#bienes_table tbody tr").remove(); 
  });

  ////////////////// Commit Nuevo consumo, se borra la tabla si hay error. 
  $('#nuevo_consumo').submit(function() {
    var columns = $('#bienes_table thead th').map(function() {
      return $(this).text();
    });

    var bienes = get_tabla_de_bienes();
    
    if(bienes.length > 0)
    {
      urlToSubmit = "/consumos_directo/crear_consumo";
      $.ajax({  
        url: urlToSubmit,
        dataType: "json",
        //contentType: "application/json",
        type: "POST",
        data: { "consumo_directo": JSON.stringify({ fecha: $("#consumo_directo_fecha").val() ,area_id: $("#consumo_directo_area_id").val(),
                                                    obra_proyecto_id: $("#consumo_directo_obra_proyecto_id").val(),bienes_tabla: bienes})  },
        success:function(result) {       
              //alert("El Consumo fue realizado exitosamente");
              //ImprimirFormulario(result.id);              
              window.location.replace("/consumos_directo");   
            },

        error: function (request, status, error) {                 
                alert("Revise los campos incompletos. El consumo no fue realizado");
                // var form_consumo_directo = jQuery(request.responseText).find('#nuevo_consumo').html()
                // $('#nuevo_consumo').html(form_consumo_directo);
              }                
      });                
    }
    else
    { alert("Debe agregar al menos un bien a consumir.")}  
    return false; // prevents normal behaviour  
  });            

  function ImprimirFormulario(consumo_id) 
  {
    $.ajax({
      url: "imprimir_formulario/?consumo_directo_id=" + consumo_id,    
      //url: "/consumos_directo/imprimir_formulario/?consumo_directo_id=" + consumo_id,      
      dataType: "json",
      //, no va, si no envias un json!!! o
      //si no queres que te devuelva un json mal formado, con caracteres codificados
      //contentType: "application/json",
      type: "post",
      data: { consumo_directo_id: consumo_id },                
      success:function(data)
          { 
            alert("a imprimir ok");
            $('#impresion').html(data);
          },
      error: function (request, status, error) 
          { alert("No se pudo imprimir el formulario"); }
      });
  }  

  function get_tabla_de_bienes()
  {
    var columns = $('#bienes_table thead th').map(function() {
      return $(this).text();
    });

    var bienes = $('#bienes_table tbody tr').map(function(i) {
    var row = {};  
    $(this).find('td').each(function(i) {    
      var rowName = columns[i];  
      row[rowName] = $(this).text();
    });  
    return row;
    }).get(); 

    return bienes;
  }

  $("#bienes_table").on('click','.remCF',function(){
    $(this).parent().parent().remove();
  });

  function blanquear_campos()
  {
    $("#bien_de_consumo_id").val("");
    $("#codigo").val("");    
    $("#consumo_directo_nombre").val("");    
    $("#cantidad_stock").val("");
    $("#cantidad_a_consumir").val("");    
    $("#categoria_clase_id").val("");   
    document.getElementById('consumos_directo_bien_de_consumo_id').options.length = 0; 
    
  }

  $("#obtener_lista_de_consumos_por_codigo_destino_y_fecha").click(function() {
    var bien_de_consumo__id = $("#bien_de_consumo_id").val();
    var area__id = $("#area_id").val();
    var fecha_inicio = $("#fecha_inicio").val();
    var fecha_fin = $("#fecha_fin").val();

    $.ajax({
      type: "get",
      dataType: "json",
      url: "/consumos_directo/traer_consumos_por_codigo_destino_y_fecha",        
      data: { bien_id: bien_de_consumo__id, area_id: area__id, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
      success: function(data){            
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
            $('#tabla_bienes').html(data)            
            if(data == "")
            { alert("No se encontraron resultados") }
      },
      error: function (request, status, error) 
          {             
            alert("Ha ocurrido un error.");
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
          }                          
      });     
  });

    $("#obtener_lista_de_consumos_por_partida_parcial_destino_y_fecha").click(function() {
    var partida_parcial = $("#partida_parcial").val();
    var area__id = $("#area_id").val();
    var fecha_inicio = $("#fecha_inicio").val();
    var fecha_fin = $("#fecha_fin").val();

    $.ajax({
      type: "get",
      dataType: "json",
      url: "/consumos_directo/traer_consumos_por_partida_parcial_destino_y_fecha",        
      data: { partida_parcial: partida_parcial, area_id: area__id, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
      success: function(data){            
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
            $('#tabla_bienes').html(data)            
            if(data == "")
            { alert("No se encontraron resultados") }
      },
      error: function (request, status, error) 
          {             
            alert("Ha ocurrido un error.");          
          }                          
      });     
  });


  function blanquear_campos_en_consumos_por_codigo_destino_y_fecha() 
  {
    $("#bien_de_consumo_nombre").val("");       
    $("#bien_de_consumo_id").val(""); 
    $("#area_nombre").val("");                  
    $("#area_id").val("");  
    $("#obra_proyecto_id").val(""); 
  }

  $("#obtener_lista_de_consumos_por_obra_proyecto_y_fecha").click(function() {
    var obra_proyecto_id = $("#obra_proyecto_id").val();      
    var fecha_inicio = $("#fecha_inicio").val();
    var fecha_fin = $("#fecha_fin").val();

    $.ajax({
      type: "get",
      dataType: "json",        
      url: "/consumos_directo/traer_consumos_por_obra_proyecto_destino_y_fecha",        
      data: { obra_proyecto_id: obra_proyecto_id, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
      success: function(data){            
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
            $('#tabla_bienes').html(data)            
            if(data == "")
              {alert("No se encontraron resultados")}
      },
      error: function (request, status, error) 
          {                         
            alert("Debe seleccionar todos los campos");
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();              
          }                          
      });     
  });


  $('#consumo_directo_nombre').bind('railsAutocomplete.select', function(event, data){
    $("#codigo").val(ObtenerCodigoEIdentificadorDeBien(data.item.value,"consumos_directo_bien_de_consumo_id"));      
    var id = data.item.id;                
    var deposito_id = $("#consumo_directo_deposito_deposito_id").val();  
    traer_bien_de_consumo_por_id_y_deposito(id, deposito_id);
  });     

  $("#consumos_directo_bien_de_consumo_id").change(function() {
      
        var id = $("#consumos_directo_bien_de_consumo_id").val();                
        var deposito_id = $("#consumo_directo_deposito_deposito_id").val();          

        if(deposito_id != "")
        {          
          traer_bien_de_consumo_por_id_y_deposito(id, deposito_id)      
        }
        else
        { 
          alert("Debe seleccionar un deposito origen")
          blanquear_campos(); 
        }        
  }); 

  function traer_bien_de_consumo_por_id_y_deposito(id, deposito_id)  
  {
    if(deposito_id != "" && deposito_id != null)
    { 
      $.ajax({
        url: "/consumos_directo/obtener_nombre_y_stock_de_bien_de_consumo_por_id_y_deposito",
        dataType: "json",
        //contentType: "application/json", no va, si no envias un json!!!
        type: "post",
        data: { bien_id: id , deposito_id: deposito_id },                
        success:function(data){                           
            $("#consumo_directo_nombre").val(data.nombre)
            $("#codigo").val(data.codigo)
            $("#bien_de_consumo_id").val(data.bien_de_consumo_id)                 
            $("#cantidad_stock").val(data.cantidad_en_stock)           
          }, 
          error: function (request, status, error) 
            { 

              blanquear_campos();
            }
        });   
    }
    else
      {alert("Debe seleccionar el deposito")}
  }

  
  $("#obtener_lista_de_consumos_y_transferencias_por_bien_y_fecha").click(function() {
    var bien_id = $("#bien_de_consumo_id").val();      
    var fecha_inicio = $("#fecha_inicio").val();
    var fecha_fin = $("#fecha_fin").val();

    if(bien_id == "")
      { 
        alert("Debe completar todos los campos") 
        return;
      } 

    $.ajax({
      type: "get",
      dataType: "json",        
      url: "/consumos_directo/traer_consumos_y_transferencias_por_nombre_y_fecha",        
      data: { bien_id: bien_id, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
      success: function(data){            
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
            $('#tabla_bienes').html(data)            
            if(data == "")
              {alert("No se encontraron resultados")}
      },
      error: function (request, status, error) 
          {                         
            alert("Ha ocurrido un error. Informe al administrador del sistema");
            blanquear_campos_en_consumos_por_codigo_destino_y_fecha();              
          }                          
      });     
  });


  function ObtenerBienDeConsumoYcantidadEnStock(codigo, deposito_id)
  {
    if(codigo != "" && deposito_id != null)
    {
      $.ajax({
        url: "/consumos_directo/obtener_nombre_de_bien_de_consumo",
        dataType: "json",
        //contentType: "application/json", no va, si no envias un json!!!
        type: "post",
        data: { codigo: codigo , deposito_id: deposito_id },                
        success:function(data){                  
            $("#consumo_directo_nombre").val(data.nombre)
            $("#bien_de_consumo_id").val(data.bien_de_consumo_id)                 
            $("#cantidad_stock").val(data.cantidad_en_stock)           
          },
          error: function (request, status, error) 
            { 
              if($("#consumo_directo_deposito_id").val() != "")
              { alert("Bien de consumo inexistente."); }
              else
              { alert("Seleccione un deposito origen")}

              blanquear_campos();
            }
        });
    }
    else
    { 
      alert("Debe seleccionar Codigo y Deposito")
          blanquear_campos(); 
    }            
  }  

  function ObtenerCodigoEIdentificadorDeBien(nom, etiqueta_bien_de_consumo_id)
  {
    $.ajax({
    url: "/bienes_de_consumo_de_recepcion/obtener_codigo_de_bien_de_consumo",
    dataType: "json",
    //contentType: "application/json", no va, si no envias un json!!!
    type: "post",
    data: { nombre: nom },                
    success:function(data){           
        if(data.length > 0)       
        {
          $("#codigo").val(data[0].detalle_adicional)          
          $("#nombre").val(data[0].nombre)
          //$("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val(data[0].id) 
          $("#"+etiqueta_bien_de_consumo_id).val(data[0].id) 
          etiqueta_bien_de_consumo_id                 
        }
        else
        {
          alert("Bien de consumo inexistente");              
        }
      },
    error: function (request, status, error) {
      alert("Bien de consumo inexistente");
      }
    });
  }

  (function() {
    jQuery(function() {
      var depositos, llenarDepositos;
      llenarDepositos = function(depositos) {
        var area, options;
        area = $('#area_origen_area_id :selected').text();
        options = $(depositos).filter("optgroup[label='" + area + "']").html();
        if (options) {
          $('#consumo_directo_deposito_deposito_id').html('<option value="">seleccione...</option>');
          return $('#consumo_directo_deposito_deposito_id').append(options);
        } 
        else {
          return $('#consumo_directo_deposito_deposito_id').empty();
        }
      };
      depositos = $('#consumo_directo_deposito_deposito_id').html();
      llenarDepositos(depositos);
      return $('#area_origen_area_id').change(function() {
        return llenarDepositos(depositos);
      });
    }); 
  }).call(this);  

  (function() {
    jQuery(function() {
      var bienes, llenarBienes;
      llenarBienes = function(bienes) {
        var clase, options;
        clase = $('#categoria_clase_id :selected').text();
        if(clase.indexOf("-") >= 0 )        
        { clase = clase.split("-")[1].trim() }

        options = $(bienes).filter("optgroup[label='" + clase + "']").html();
        if (options) {
          $('#consumos_directo_bien_de_consumo_id').html('<option value="">seleccione...</option>');
          return $('#consumos_directo_bien_de_consumo_id').append(options);
        } 
        else {
          return $('#consumos_directo_bien_de_consumo_id').empty();
        }
      };
      bienes = $('#consumos_directo_bien_de_consumo_id').html();
      llenarBienes(bienes);
      return $('#categoria_clase_id').change(function() {
        return llenarBienes(bienes);
      });
    }); 
  }).call(this);
});     



