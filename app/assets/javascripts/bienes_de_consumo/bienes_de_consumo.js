//USE ESTA
var ready = function() {

  //************ Muestra una lista al colocar los 4 digitos del codigo  **********//
  // //$("#clase_codigo").keypress(function(){   
  // $("#bien_de_consumo_codigo").on("keyup", function(e) {
  //     var str = this.value;
  //     var n = str.length;      
      
  //     if(n == 4)
  //     { buscar_codigos_existentes(str); }
  //     else
  //     { 
  //       $('#titulo').html("");
  //       $('#tabla_items_existentes').html(""); 
  //     }         
  // });   

  // function buscar_codigos_existentes(codigo)
  // {   
  //   $.ajax({
  //     type: "get",
  //     dataType: "json",
  //     url: "/bienes_de_consumo/traer_clases_con_codigo_de_bien_existente",      
  //     data: { codigo: codigo },        
  //     success: function(data){            
  //           //BlanquearCampos();
  //           $('#titulo').html("<b> Clases con codigo de Bien de consumo existente </b>");
  //           $('#tabla_items_existentes').html(data);
  //     },
  //     error: function (request, status, error) 
  //         {             
  //           alert("Ha ocurrido un error");
  //         }
  //   });       
  // }
  //********************************************************************//

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
};

$(document).ready(ready);
$(document).on('page:load', ready);