$(document).on("ready page:load", function() {
  //mascara entero, 6
  $('#cantidad_a_consumir').inputmask('999999', { clearMaskOnLostFocus: true, placeholder: ' ' })      
  
  var currentDate = new Date();
  $('#consumo_directo_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });
  $("#consumo_directo_fecha").datepicker("setDate", currentDate);


  $("#consumo_directo_area_id").change(function() { 
    identificador_del_control = $("#consumo_directo_area_id").val(); 
    traer_responsable(identificador_del_control)    
  });

  $("#area_origen_area_id").change(function() {  
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
            if($("#consumo_directo_deposito_id").val() != "")
            { alert("Bien de consumo inexistente."); }
            else
            { alert("Seleccione un deposito origen")}
          }
      });
  });


  $("#agregar_bien_a_consumir").click(function() {  
    var array_bienes = get_tabla_de_bienes() 
    var bien_encontrado = array_bienes.filter(function( obj ) { return obj.Codigo == $("#codigo").val(); })
    if (bien_encontrado.length > 0)
    { 
      // var nueva_cantidad = bien_encontrado[0]["Cantidad a consumir"] + $("#cantidad_a_consumir").val();

      // var bien_id = bien_encontrado[0].Id
      // var cod = bien_encontrado[0].Codigo 
      // var nom = bien_encontrado[0].Nombre 
      // var cant_stock = bien_encontrado[0]["Cantidad en stock"]
      // var cant_consumir = bien_encontrado[0]["Cantidad a consumir"]
      alert("El Bien de consumo ya fue agregado")
      // var nuevo_row = '<tr id='+bien_id+'><td style="display:none;">'+bien_id+'</td> <td>'+cod+'</td> <td>'+nom+'</td> <td>'+cant_stock+'</td> <td>'+cant_consumir+'</td> <td> Ud </td></tr>'
      // tr_id = "tr#"+bien_id;
      // $(tr_id).parent().replaceWith(nuevo_row);      
      blanquear_campos()
      return ;
    }

    var bien_id = $("#bien_de_consumo_id").val();
    var cod = $("#codigo").val();    
    var nom = $("#nombre").val();    
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
              alert("El Consumo fue realizado exitosamente");
              //ImprimirFormulario(result.id);              
              window.location.replace("/consumos_directo");   
            },

        error: function (request, status, error) {                 
                alert("Revise los campos incompletos. El consumo no fue realizado");
                //var form_consumo_directo = jQuery(request.responseText).find('#nuevo_consumo').html()
                //$('#nuevo_consumo').html(form_consumo_directo);
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
    $("#nombre").val("");    
    $("#cantidad_stock").val("");
    $("#cantidad_a_consumir").val("");
    $("#consumo_directo_deposito_id").val("");
    //$("#consumo_directo_deposito_id option:selected" ).text("");
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
}); 

//Id      Codigo  Nombre        Cantidad en stock   Cantidad a consumir   
//        1111    mouse optico  100.0               100                    
//        2222    tijera        100.0               100                    
