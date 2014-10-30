/////////////////// Vista nueva recepcion. Agrear y quitar Bienes de consumo ///////////////////        
 $(document).ready(function(){
      $( "#costo" ).blur(function() {
           if($('#cantidad').val() != "" &&  $("#costo").val()  != "")                  
           $('#costoTotal').val(parseFloat($('#costo').val()) * parseInt($('#cantidad').val())); 
           else
           $('#costoTotal').val("");
           end           
      });      

      //$("#costo").inputmask("9999999.9999")    
      
      $("#traer_bien_de_consumo").click(function() {  
        var cod = $("#codigo").val();        
        $.ajax({
                url: "/recepciones_de_bien_de_consumo/obtener_nombre_de_bien_de_consumo",
                dataType: "json",
                //contentType: "application/json", no va, si no envias un json!!!
                type: "post",
                data: { codigo: cod },                
                success:function(data){                  
                  $("#nombre").val(data[0].nombre)                
                },
                error: function (request, status, error) {
                  alert("Bien de consumo inexistente");
                }
              });
      });
});