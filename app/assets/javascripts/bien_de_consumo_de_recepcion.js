/////////////////// Vista nueva recepcion. Agrear y quitar Bienes de consumo ///////////////////        
 $(document).ready(function(){
  $( "#bien_de_consumo_de_recepcion_costo" ).blur(function() {
      if($('#bien_de_consumo_de_recepcion_cantidad').val() != "" &&  
        $("#bien_de_consumo_de_recepcion_costo").val()  != "")                  
        $('#costoTotal').val(parseFloat($('#bien_de_consumo_de_recepcion_costo').val()) * parseInt($('#bien_de_consumo_de_recepcion_cantidad').val())); 
      else
        $('#costoTotal').val("");
      end           
      
      });      

      //$("#costo").inputmask("9999999.9999")    
      
      $("#traer_bien_de_consumo").click(function() {  
        var cod = $("#codigo").val();        
        $.ajax({
          url: "/bienes_de_consumo_de_recepcion/obtener_nombre_de_bien_de_consumo",
          dataType: "json",
          //contentType: "application/json", no va, si no envias un json!!!
          type: "post",
          data: { codigo: cod },                
          success:function(data){                  
            $("#nombre").val(data[0].nombre)
            $("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val(data[0].id)                  
            },
          error: function (request, status, error) {
            alert("Bien de consumo inexistente");
            }
          });
      });
});