var ready = function() {

  $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
    blanquear_campos_comobos_clase_y_bienes();
    $("#item_stock_bien_de_consumo_id").val(data.item.id);
    traer_costo_de_bien_de_consumo(data.item.id);
    traer_cantidad_en_stock_en_suministro(data.item.id);
  });

  function traer_costo_de_bien_de_consumo(bien_de_consumo_id)
  {
    $.ajax({
      url: "/bienes_de_consumo/traer_costo_de_bien_de_consumo",
      dataType: "json",
      type: "post",
      data: { bien_id: bien_de_consumo_id },                
      success:function(data){                           
          $("#costo_actual").val(data)
        }, 
        error: function (request, status, error) 
          { 
                       
          }
      });   
  }

  function traer_cantidad_en_stock_en_suministro(bien_de_consumo_id)
  {
    $.ajax({
      url: "/items_stock/traer_cantidad_en_stock_en_suministro",
      dataType: "json",
      type: "post",
      data: { bien_id: bien_de_consumo_id },                
      success:function(data){                           
          $("#cantidad_en_stock").val(data)
        }, 
        error: function (request, status, error) 
          { 
                       
          }
      });   
  }


  $("#items_stock_bien_de_consumo_id").change(function() { 
    id_de_bien = $("#items_stock_bien_de_consumo_id").val(); 
    $("#item_stock_bien_de_consumo_id").val(id_de_bien);
    $("#bien_de_consumo_nombre").val($("#items_stock_bien_de_consumo_id option:selected").text());
    traer_costo_de_bien_de_consumo(id_de_bien);
    traer_cantidad_en_stock_en_suministro(id_de_bien);  
  });

(function() {
    jQuery(function() {
      var bienes, llenarBienes;
      llenarBienes = function(bienes) {
        var clase, options;
        clase = $('#categoria_clase_id :selected').text();
        if(clase.indexOf("-") >= 0 )        
        { clase = clase.split("-")[1].trim() }

        options = $(bienes).filter("optgroup[label='" + clase + "']").html();
        if (options) {
          $('#items_stock_bien_de_consumo_id').html('<option value="">seleccione...</option>');
          return $('#items_stock_bien_de_consumo_id').append(options);
        } 
        else {
          return $('#items_stock_bien_de_consumo_id').empty();
        }
      };
      bienes = $('#items_stock_bien_de_consumo_id').html();
      llenarBienes(bienes);
      return $('#categoria_clase_id').change(function() {
        return llenarBienes(bienes);
      });
    }); 
  }).call(this);

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

    function blanquear_campos_comobos_clase_y_bienes()
  {
    $("#categoria_clase_id").val("");
    $("#items_stock_bien_de_consumo_id").empty();           
  }

};

$(document).ready(ready);
$(document).on('page:load', ready);