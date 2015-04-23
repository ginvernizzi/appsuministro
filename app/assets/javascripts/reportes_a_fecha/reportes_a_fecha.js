$(document).on("ready page:load", function() {  
  var currentDate = new Date();
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

  $("#traer_items_stock").on('click', function() {      
    var fecha_inicio =  $("#fecha_inicio").val();  
    var fecha_fin =  $("#fecha_fin").val(); 

    traer_reportes_a_fecha(fecha_inicio, fecha_fin);
  });

  $("#reportes_a_fecha_traer_todos_los_items").on('click', function() {      
    var fecha_inicio = "";  
    var fecha_fin = ""; 
    traer_reportes_a_fecha(fecha_inicio, fecha_fin);
  });

  function traer_reportes_a_fecha(fecha_inicio, fecha_fin)
  {
    $.ajax({
        type: "get",
        dataType: "json",
        url: "/reportes_a_fecha/traer_items_stock",        
        data: { fecha_inicio: fecha_inicio, fecha_fin:fecha_fin },
        success: function(data){            
              $('#tabla_items').html(data)
        }
    });
    return false;
  }
});