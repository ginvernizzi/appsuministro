$(document).on("ready page:load", function() {
 
  //$('#clase_codigo').inputmask('99999')      
  //$("#clase_codigo").keypress(function(){   
  $("#clase_codigo").on("keyup", function(e) {
      var str = this.value;
      var n = str.length;      
      
      if(n == 5)
      { buscar_codigos_existentes(str); }
      else
      { 
        $('#titulo').html("")          
        $('#tabla_items_existentes').html("") 
      }         
  }); 

  function buscar_codigos_existentes(codigo)
  {   
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/clases/traer_partidas_parciales_con_codigo_de_clase_existente",      
      data: { codigo: codigo },        
      success: function(data){            
            //BlanquearCampos();
            $('#titulo').html("<b> Partidas Parciales con codigo de clase existente  </b>");
            $('#tabla_items_existentes').html(data);
      },
      error: function (request, status, error) 
          {             
            alert("Ha ocurrido un error");
          }
    });       
  }
  
  $("#buscar_nombres_repetidos").on('click', function() {                        
      buscar_nombres_existentes($("#clase_nombre").val());      
      //$('#tabla_items_existentes').html("") 
  })

  function buscar_nombres_existentes(nombre)
  {       
    $.ajax({
      type: "get",
      dataType: "json",
      url: "/clases/traer_partidas_parciales_con_nombre_de_clase_similar",      
      data: { nombre: nombre },        
      success: function(data){                
            $('#titulo').html("<b> Partidas Parciales con nombre de clase similares <b>");
            $('#tabla_items_existentes').html(data);
      },
      error: function (request, status, error) 
          {                       
            alert("Ha ocurrido un error");
          }
    });       
  }

  $('#clase_nombre').bind('railsAutocomplete.select', function(event, data){          
    $("#categoria_clase_id").val(data.item.id);    
    $("#categoria_clase_id").change();
  });

  $('#clase_nombre_all_clases').on('railsAutocomplete.select', function(event, data){ 
    $("#clase_id").val(data.item.id);
  });

  $("#traer_clase_por_id").on('click', function(){
      traer_clase_por_id($('#clase_id').val());
  });


  function traer_clase_por_id(clase_id)
  {
    $.ajax({
    type: "get",
    dataType: "json",
    url: "/clases/traer_clase_por_id",            
    data: { clase_id: clase_id }, 
    success: function(data){            
      $('#tabla_todas_las_clases').html(data)
    },
    error: function (request, status, error) 
        { 
          alert("Ha ocurrido un error. No se mostrarán los items");
        }
    });       
  }

});
