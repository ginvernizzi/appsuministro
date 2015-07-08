/////////////////// Vista nueva recepcion. Agrear y quitar Bienes de consumo ///////////////////        
 $(document).ready(function(){
  $("#codigo").inputmask("9.9.9.99999.9999", { clearMaskOnLostFocus: true }) 

  $( "#bien_de_consumo_de_recepcion_costo" ).blur(function() {
      if($('#bien_de_consumo_de_recepcion_cantidad').val() != "" &&  
        $("#bien_de_consumo_de_recepcion_costo").val()  != "")      
      {            
        $('#costoTotal').val(parseFloat($('#bien_de_consumo_de_recepcion_costo').val()) * parseInt($('#bien_de_consumo_de_recepcion_cantidad').val())); 
      }
      else
      {  $('#costoTotal').val(""); }          
      
      });          

      //$("#costo").inputmask("9999999.9999")    
      
      $("#traer_bien_de_consumo").click(function() {  
        var cod = $("#codigo").val();     
        ObtenerNombreEIdentificadorDeBien(cod);        
      });

      $('#categoria_bien_de_consumo_id').change(function() {        
        var nom = this.options[this.selectedIndex].innerHTML 
        ObtenerCodigoEIdentificadorDeBien(nom);        
      });

      function ObtenerNombreEIdentificadorDeBien(cod)
      {
        $.ajax({
        url: "/bienes_de_consumo_de_recepcion/obtener_nombre_de_bien_de_consumo",
        dataType: "json",
        //contentType: "application/json", no va, si no envias un json!!!
        type: "post",
        data: { codigo: cod },                
        success:function(data){
          if(data.length > 0)       
            {                  
              $("#nombre").val(data[0].nombre)
              $("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val(data[0].id)                  
            }
            else
            {  
              alert("Bien de consumo inexistente");                
              blanquear_campos();  
            }
          },
        error: function (request, status, error) {
          alert("Bien de consumo inexistente");
              blanquear_campos();
          }
        });
      }

    function blanquear_campos()
    {
      $("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val("");
      $("#codigo").val("");    
      $("#nombre").val("");    
    }

      function ObtenerCodigoEIdentificadorDeBien(nom)
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
              $("#bien_de_consumo_de_recepcion_bien_de_consumo_id").val(data[0].id)                  
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
});