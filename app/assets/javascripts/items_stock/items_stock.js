$(document).on("ready page:load", function() {  

  $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#bien_de_consumo_id").val(data.item.id);
  });

  $('#area_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#area_id").val(data.item.id);         
  })


  $("#traer_todos_los_items_stock").on('click', function() {                
    traer_todos_los_items_de_stock();
  });

  $("#traer_por_bien_de_consumo_y_area").on('click', function() {    
    var bien_id = $("#bien_de_consumo_id").val();
    var area_id = $("#area_id").val();
    if(bien_id != null &&  bien_id != "" && area_id != null && area_id != "")
      { traer_items_por_bien_y_area(bien_id, area_id); }
    else 
      { 
        alert ("Debe seleccionar el Bien de consumo y Area") 
        BlanquearCampos();
      }
  });

  function traer_todos_los_items_de_stock()
  {    
    $.ajax({
    type: "get",
    dataType: "json",
    url: "/items_stock/traer_todos_los_items_stock",              
    success: function(data){            
          BlanquearCampos();

          $('#tabla_items').html(data)
    },
    error: function (request, status, error) 
        { 
          alert("Debe seleccionar Bien de consumo y Area"); 
          BlanquearCampos();
        }
    });       
  }

  function traer_items_por_bien_y_area(bien_id, area_id)
  {    
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/items_stock/traer_items_stock_por_bien_y_area",        
      data: { bien_de_consumo_id: bien_id, area_id: area_id },
      success: function(data){         
            if (data  == "")
              { alert("No se encontraron resultados") }   
            $('#tabla_items').html(data)
      },
      error: function (request, status, error) 
          { 
            alert("Debe seleccionar Bien de consumo y Area"); 
            BlanquearCampos();
          }
    });       
  }

  function BlanquearCampos()
  {
    $("#bien_de_consumo_id").val("");
    $("#bien_de_consumo_nombre").val("");              
    $("#area_id").val("");
    $("#area_nombre").val("");
  }

});