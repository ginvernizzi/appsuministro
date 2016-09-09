$(document).on("ready page:load", function() {

  $("#traer_lista_de_ingresos_manuales").click(function() {
    var fecha_inicio = $("#fecha_inicio").val();
    var fecha_fin = $("#fecha_fin").val();

    $.ajax({
      type: "get",
      dataType: "json",
      url: "/registro_ingreso_manual/traer_ingresos_manuales",
      data: { fecha_inicio:fecha_inicio, fecha_fin:fecha_fin },
      success: function(data){
            $('#tabla_ingresos_manuales').html(data)
            if(data == "")
            { alert("No se encontraron resultados") }
      },
      error: function (request, status, error)
          {
            alert("Ha ocurrido un error.");
            //blanquear_campos_en_consumos_por_codigo_destino_y_fecha();
          }
      });
  });

});
