$(document).on("ready page:load", function() {  
  	var currentDate = new Date();  

	$('#transferencia_fecha').datepicker
	({
    showOn: 'both', 
  	autoclose: true,
  	format: 'dd/mm/yyyy',
  	language: "es"
	});
	$("#transferencia_fecha").datepicker("setDate", currentDate);


  $("#transferencia_area_origen_area_id").change(function() { 
    identificador_del_control = $("#transferencia_area_origen_area_id").val(); 
    traer_responsable(identificador_del_control)    
  });

  $("#transferencia_area_id").change(function() {  
    identificador_del_control = $("#transferencia_area_id").val();
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

  $("#traer_bien_de_consumo_y_cantidad_stock_tranferencia").click(function() {        
      var cod = $("#codigo").val();          
      var deposito_id = $("#transferencia_deposito_origen_deposito_id").val();       
      ObtenerBienDeConsumoYcantidadEnStock(cod, deposito_id);
  });

  $("#agregar_bien_a_transferir").click(function() {
    var array_bienes = get_tabla_de_bienes() 
    var bien_encontrado = array_bienes.filter(function( obj ) { return obj.Codigo == $("#codigo").val(); })
    if (bien_encontrado.length > 0)
    { 
      alert("El Bien de consumo ya fue agregado")    
      blanquear_campos()
      return ;
    }
    
    var bien_id = $("#bien_de_consumo_id").val();    
    var cod = $("#codigo").val();    
    var nom = $("#transferencia_nombre").val();    
    var cant_stock = $("#cantidad_stock").val();
    var cant_transferir = $("#cantidad_a_transferir").val();
    var depo_id = $("#transferencia_deposito_origen_deposito_id").val();
    var depo = $("#transferencia_deposito_origen_deposito_id option:selected").text();

    if(cant_transferir)
    {
      if(cant_transferir == 0 || parseInt(cant_transferir) > parseInt(cant_stock) || cant_stock == 0)
      { alert("El stock es insufuciente para transferir.") }
      else
      {
        $('#bienes_table').append('<tr id='+bien_id+'> <td style="display:none;">'+bien_id+'</td> <td style="display:none;">'+depo_id+'</td> <td>'+cod+'</td> <td>'+nom+'</td> <td>'+depo+'</td><td>'+cant_stock+'</td><td>'+cant_transferir+'</td><td> Ud </td><td> <a href="javascript:void(0);" class="remCF">Eliminar</a> </td> </tr>'); 
        blanquear_campos()
      }
    }
    else
    { alert("Debe ingresar la cantidad a transferir.") }
  });

  $("#eliminar_todos_los_bienes").click(function() {          
    $("#bienes_table tbody tr").remove(); 
  });

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

  $('#nueva_transferencia').submit(function() {
    var columns = $('#bienes_table thead th').map(function() {
      return $(this).text();
    });

    var bienes = get_tabla_de_bienes();    

    if(bienes.length > 0)
    {
      urlToSubmit = "/transferencias/crear_transferencia";
      $.ajax({  
        url: urlToSubmit,
        dataType: "json",
        //contentType: "application/json",
        type: "POST",
        data: { "transferencia": JSON.stringify({ fecha: $("#transferencia_fecha").val() ,
                                                  deposito_id: $("#transferencia_deposito_destino_deposito_id").val(),
                                                  area_id: $("#transferencia_area_destino_area_id").val(), 
                                                  bienes_tabla: bienes}) },
        success:function(result) {       
              alert("La transferencia fue realizada exitosamente");
              //ImprimirFormulario(result.id);              
              window.location.replace("/transferencias");   
            },

        error: function (request, status, error) { 
                alert("Revise los campos incompletos. La transferencia no fue realizada");
                //var form_consumo_directo = jQuery(request.responseText).find('#nuevo_consumo').html()
                //$('#nuevo_consumo').html(form_consumo_directo);                 
              }                
      });                
    }
    else
    { alert("Debe agregar al menos un bien a transferir.")}  
    return false; // prevents normal behaviour  
  });            

  function blanquear_campos()
  {
    $("#bien_de_consumo_id").val("");
    $("#codigo").val("");    
    $("#nombre").val("");    
    $("#cantidad_stock").val("");
    $("#cantidad_a_transferir").val("");
    $("#categoria_clase_id").val("");   
    $("#transferencias_bien_de_consumo_id").val(""); 
    $("#transferencia_nombre").val("");  

    //Vaciar lista de bienes
    document.getElementById('transferencias_bien_de_consumo_id').options.length = 0;   
  }

  (function() {
    jQuery(function() {
      var depositos, llenarDepositos;
      llenarDepositos = function(depositos) {
        var area, options;
        area = $('#transferencia_area_id :selected').text();
        options = $(depositos).filter("optgroup[label='" + area + "']").html();
        if (options) {
          $('#transferencia_deposito_id').html('<option value="">seleccione...</option>');
          return $('#transferencia_deposito_id').append(options);
        } 
        else {
          return $('#transferencia_deposito_id').empty();
        }
      };
      depositos = $('#transferencia_deposito_id').html();
      llenarDepositos(depositos);
      return $('#transferencia_area_id').change(function() {
        return llenarDepositos(depositos);
      });
    }); 
  }).call(this);

  (function() {
    jQuery(function() {
      var depositos, llenarDepositos;
      llenarDepositos = function(depositos) {
        var area, options;
        area = $('#transferencia_area_origen_area_id :selected').text();
        options = $(depositos).filter("optgroup[label='" + area + "']").html();
        if (options) {
          $('#transferencia_deposito_origen_deposito_id').html('<option value="">seleccione...</option>');
          return $('#transferencia_deposito_origen_deposito_id').append(options);
        } 
        else {
          return $('#transferencia_deposito_origen_deposito_id').empty();
        }
      };
      depositos = $('#transferencia_deposito_origen_deposito_id').html();
      llenarDepositos(depositos);
      return $('#transferencia_area_origen_area_id').change(function() {
        return llenarDepositos(depositos);
      });
    }); 
  }).call(this);

  (function() {
    jQuery(function() {
      var depositos, llenarDepositos;
      llenarDepositos = function(depositos) {
        var area, options;
        area = $('#transferencia_area_destino_area_id :selected').text();
        options = $(depositos).filter("optgroup[label='" + area + "']").html();
        if (options) {
          $('#transferencia_deposito_destino_deposito_id').html('<option value="">seleccione...</option>');
          return $('#transferencia_deposito_destino_deposito_id').append(options);
        } 
        else {
          return $('#transferencia_deposito_destino_deposito_id').empty();
        }
      };
      depositos = $('#transferencia_deposito_destino_deposito_id').html();
      llenarDepositos(depositos);
      return $('#transferencia_area_destino_area_id').change(function() {
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
          $('#transferencias_bien_de_consumo_id').html('<option value="">seleccione...</option>');
          return $('#transferencias_bien_de_consumo_id').append(options);
        } 
        else {
          return $('#transferencias_bien_de_consumo_id').empty();
        }
      };
      bienes = $('#transferencias_bien_de_consumo_id').html();
      llenarBienes(bienes);
      return $('#categoria_clase_id').change(function() {
        return llenarBienes(bienes);
      });
    }); 
  }).call(this);

  $('#transferencia_nombre').bind('railsAutocomplete.select', function(event, data){
    $("#codigo").val(ObtenerCodigoEIdentificadorDeBien(data.item.value,"transferencias_bien_de_consumo_id"));      
    var id = data.item.id;                
    var deposito_id = $("#transferencia_deposito_origen_deposito_id").val();  
    traer_bien_de_consumo_por_id_y_deposito(id, deposito_id);
  });  

  $("#transferencias_bien_de_consumo_id").change(function() {
    var id = $("#transferencias_bien_de_consumo_id").val();                
    var deposito_id = $("#transferencia_deposito_origen_deposito_id").val(); 

    traer_bien_de_consumo_por_id_y_deposito(id, deposito_id)         
  }); 

  function traer_bien_de_consumo_por_id_y_deposito(id, deposito_id)  
  {    
    if(id != null && id != "" && deposito_id != null && deposito_id != "")
    { 
      $.ajax({
        url: "/consumos_directo/obtener_nombre_y_stock_de_bien_de_consumo_por_id_y_deposito",
        dataType: "json",
        //contentType: "application/json", no va, si no envias un json!!!
        type: "post",
        data: { bien_id: id , deposito_id: deposito_id },                
        success:function(data){                                                
            $("#transferencia_nombre").val(data.nombre)
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
    { 
      alert("Debe seleccionar un deposito y un bien de consumo") 
      blanquear_campos(); 
    }
  }

  function traer_bien_de_consumo(codigo, deposito_id)
  {
    var cod = codigo;
    var depositoId = deposito_id;

    if($("#codigo").val() != "" && $("#transferencia_deposito_origen_deposito_id").val() != null)
    {
      $.ajax({
        url: "/consumos_directo/obtener_nombre_de_bien_de_consumo",
        dataType: "json",
        //contentType: "application/json", no va, si no envias un json!!!
        type: "post",
        data: { codigo: cod , deposito_id: depositoId },                
        success:function(data){                  
            $("#nombre").val(data.nombre)
            $("#bien_de_consumo_id").val(data.bien_de_consumo_id)                 
            $("#cantidad_stock").val(data.cantidad_en_stock)           
          }, 
          error: function (request, status, error) 
            { 
              if($("#transferencia_deposito_origen_deposito_id").val() != "")
              { alert("Bien de consumo inexistente."); }
              else
              { alert("Seleccione un deposito origen") }
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
          $("#transferencia_nombre").val(data[0].nombre)
          //$("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val(data[0].id) 
          $("#"+etiqueta_bien_de_consumo_id).val(data[0].id)                           
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
            $("#transferencia_nombre").val(data.nombre)
            $("#transferencias_bien_de_consumo_id").val(data.bien_de_consumo_id)                 
            $("#cantidad_stock").val(data.cantidad_en_stock)           
          },
          error: function (request, status, error) 
            { 
              if($("#transferencia_deposito_id").val() != "")
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
}); 




	