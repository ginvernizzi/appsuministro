$(document).on("ready page:load", function() {
  //MASCARAS
  //$('#cantidad_a_consumir').inputmask('999999', { clearMaskOnLostFocus: true, placeholder: ' ' })    
  $("#codigo").inputmask("9.9.9.99999.9999", { clearMaskOnLostFocus: true })   
  $("#documento_principal").inputmask("9999-99999999", { clearMaskOnLostFocus: true }) 
  //

  var currentDate = new Date();
  $('#recepcion_de_bien_de_consumo_en_stock_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });
  $("#recepcion_de_bien_de_consumo_en_stock_fecha").datepicker("setDate", currentDate);

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

  //////////// AUTOCOMPLETAR VER CONSUMOS POR CODIGO Y DESTINO ///////////
  $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#bien_de_consumo_id").val(data.item.id);       
  });
  ////////////////////////////////////////////////////////////////////////
     
  $("#traer_recepciones_fecha").click(function() {        
      var documento_principal = $("#documento_principal").val();      
      var fecha_inicio = $("#fecha_inicio").val();
      var fecha_fin = $("#fecha_fin").val();

      $.ajax({
        type: "get",
        dataType: "json",
        url: "/recepciones_de_bien_de_consumo_en_stock/traer_recepciones_por_fecha",        
        data: { documento_principal: documento_principal, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
        success: function(data){            
              blanquear_campos();
              $('#tabla_recepciones').html(data)            
        },
        error: function (request, status, error) 
            {             
              alert("Debe seleccionar todos los campos");
              blanquear_campos();
            }                          
        });     
    });

  
    $("#traer_recepciones_finalizadas_por_bien").click(function() {        
      var bien_id = $("#bien_de_consumo_id").val();      
      var fecha_inicio = $("#fecha_inicio").val();
      var fecha_fin = $("#fecha_fin").val();

      $.ajax({
        type: "get",
        dataType: "json",
        url: "/recepciones_de_bien_de_consumo_en_stock/traer_recepciones_por_bien_y_fecha",        
        data: { bien_id: bien_id, fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
        success: function(data){            
              blanquear_campos();
              $('#tabla_recepciones').html(data)            
        },
        error: function (request, status, error) 
            {             
              alert("Debe seleccionar todos los campos");
              blanquear_campos();
            }                          
        });     
    });

    function blanquear_campos() 
    {
        $("#documento_principal_nombre").val("");                      
        $("#documento_principal_id").val("");        
        $("#bien_de_consumo_nombre").val("");                      
        $("#bien_de_consumo_id").val("");    
    }
});

//Id      Codigo  Nombre        Cantidad en stock   Cantidad a consumir   
//        1111    mouse optico  100.0               100                    
//        2222    tijera        100.0               100                    

