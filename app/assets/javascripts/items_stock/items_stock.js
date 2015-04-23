$(document).on("ready page:load", function() {  

 $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
  $("#bien_de_consumo_id").val(data.item.id); 
  var bien_id = $("#bien_de_consumo_id").val();    
  traer_items_por_bien(bien_id);
 });

   $("#traer_todos_los_items").on('click', function() {    
    var bien_id = "";
    traer_items_por_bien(bien_id);
   });

   function traer_items_por_bien(bien_id)
   {    
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/items_stock/traer_items_stock_por_bien",        
      data: { bien_de_consumo_id: bien_id },
      success: function(data){            
            $('#tabla_items').html(data)
      }
    });       
   }
});