//USE ESTA
var ready = function() {

  $('#bien_de_consumo_clase_id').change(function() {

    var clase_id = $('#bien_de_consumo_clase_id').val()
    traer_items_de_la_clase(clase_id);
  });

  $('#clase_nombre').on('railsAutocomplete.select', function(event, data){ 
    traer_items_de_la_clase(data.item.id);
  });

    function traer_items_de_la_clase(clase_id)
  {   
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/bienes_de_consumo/traer_items_de_la_clase",      
      data: { clase_id: clase_id },        
      success: function(data){            
            //BlanquearCampos();
            $('#titulo').html("<b> Items de la clase </b>");
            $('#tabla_items_existentes').html(data);
      },
      error: function (request, status, error) 
          {             
            alert("Ha ocurrido un error");
          }
    });       
  }

  $("#buscar_clases_con_nombres_bienes_repetidos").on('click', function() {              
      buscar_nombres_existentes($("#bien_de_consumo_nombre").val());      
  })

  function buscar_nombres_existentes(nombre)
  {       
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/bienes_de_consumo/traer_clases_con_nombre_de_bien_de_consumo_similar",      
      data: { nombre: nombre },        
      success: function(data){                
            $('#titulo').html("<b> Clases con nombre de Bien de Consumo similares <b>");
            $('#tabla_items_existentes').html(data);
      },
      error: function (request, status, error) 
          {                       
            alert("Ha ocurrido un error");
          }
    });       
  }

  $('#bien_de_consumo_nombre').on('railsAutocomplete.select', function(event, data){ 
    $("#bien_de_consumo_id").val(data.item.id);
  });

  $("#traer_item_por_id").on('click', function(){
    if($('#bien_de_consumo_id').val() != "")
    {
      traer_item_por_id($('#bien_de_consumo_id').val());
    }
    else
    {
      alert("Debe seleccionar un item");
    }

  });


  function traer_item_por_id(bien_de_consumo_id)
  {
    $.ajax({
    type: "get",
    dataType: "json",
    url: "/bienes_de_consumo/traer_item_por_id",            
    data: { bien_de_consumo_id: bien_de_consumo_id }, 
    success: function(data){          
      $('#bien_de_consumo_nombre').val(""); 
      $('#bien_de_consumo_id').val("");
      $('#tabla_all_items').html(data)
    },
    error: function (request, status, error) 
        { 
          alert("Ha ocurrido un error. No se mostrarán los items");
        }
    });       
  }

  
  $("#traer_todos_los_items").on('click', function(){
      traer_todos_los_items();
  });

  function traer_todos_los_items()
  {
    $.ajax({
    type: "get",
    dataType: "json",
    url: "/bienes_de_consumo/traer_todos_los_items",            
    data: { }, 
    success: function(data){          
      $('#bien_de_consumo_nombre').val(""); 
      $('#bien_de_consumo_id').val("");
      $('#tabla_all_items').html(data)
    },
    error: function (request, status, error) 
        { 
          alert("Ha ocurrido un error. No se mostrarán los items");
        }
    });       
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);