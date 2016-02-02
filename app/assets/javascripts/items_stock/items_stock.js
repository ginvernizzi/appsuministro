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


  $("#traer_todos_los_items_stock_con_stock_minimo_superado").on('click', function() {                
    traer_items_stock_minimo_superado();
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

    $("#traer_items_stock_minimo_por_bien_de_consumo_y_area").on('click', function() {    
    var bien_id = $("#bien_de_consumo_id").val();
    var area_id = $("#area_id").val();
    if(bien_id != null &&  bien_id != "" && area_id != null && area_id != "")
    { traer_items_stock_minimo_superado_por_bien_y_area(bien_id, area_id); }
    else 
    { 
      alert ("Debe seleccionar el Bien de consumo y Area") 
      BlanquearCampos();
    }
  });

  $("#traer_todos_los_items_stock_con_stock_minimo_superado").click();

    

  function traer_todos_los_items_de_stock()
  {    
    var urlString = "/items_stock/traer_todos_los_items_stock";    
    traer_todos_los_items_por_ajax(urlString);     
  }

  function traer_items_por_bien_y_area(bien_id, area_id)
  {    
    var urlString = '/items_stock/traer_items_stock_por_bien_y_area';
    traer_items_por_bien_y_area_por_ajax(urlString, bien_id, area_id);
  }

  function traer_items_stock_minimo_superado()
  {    
    var urlString = "/items_stock/traer_items_stock_minimo_superado";
    traer_todos_los_items_por_ajax(urlString);
  }

  function traer_items_stock_minimo_superado_por_bien_y_area(bien_id, area_id)
  {    
    var urlString = "/items_stock/traer_items_stock_minimo_superado_por_bien_y_area";
    traer_items_por_bien_y_area_por_ajax(urlString, bien_id, area_id);    
  }


  function traer_todos_los_items_por_ajax(urlString)
  {
    $.ajax({
    type: "get",
    dataType: "json",
    url: urlString,              
    success: function(data){            
          BlanquearCampos();
          $('#tabla_items').html(data)
    },
    error: function (request, status, error) 
        { 
          alert("Ha ocurrido un error. No se mostrarán los items");
        }
    });       
  }

  function traer_items_por_bien_y_area_por_ajax(urlString, bien_id, area_id)
  {
      $.ajax({
      type: "get",
      dataType: "json",
      url: urlString,        
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