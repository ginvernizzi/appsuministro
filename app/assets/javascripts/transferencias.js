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

   $("#transferencia_area_id").change(function() {  
    var areaId = $("#transferencia_area_id").val();        
    
    $.ajax({
      url: "/consumos_directo/obtener_responsable_de_area",
      dataType: "json",
      //contentType: "application/json", no va, si no envias un json!!!
      type: "post",
      data: { area_id: areaId },                
      success:function(data){                  
          $("#responsable").val(data.responsable)              
        },
        error: function (request, status, error) 
          { 
          //   alert("Area erronea"); 
          }
      });
  });

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
}); 


	