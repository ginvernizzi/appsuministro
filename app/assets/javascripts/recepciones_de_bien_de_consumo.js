 $(document).ready(function(){
  $('#recepcion_de_bien_de_consumo_fecha').datepicker({
    showMonthAfterYear: false,
    showOn: 'both',
    buttonImage: 'media/img/calendar.png',
    buttonImageOnly: true,    
    format: 'dd/mm/yyyy',
  },
  $.datepicker.regional['es']
  );
});

/////////////////// Vista nueva recepcion. Agrear y quitar Documentos ///////////////////  
  $(document).ready(function(){  
      var tableName = "#recepcion_documento";
      var table = document.getElementById("recepcion_documento");  
      $("#agregar_doc").click(function() 
      {    
           //var numeroFila = $('#numeroDeFila').val();
           //var numeroFila = gon.numeroDeFila           
          //Validacion
          if($('#numero_doc_secundario').val().length != 0 ||  $("#tds_tipo_de_documento_secundario_id").val()  != "")
          {           
            var htmlToAppend = '<tr id="pn'+ gon.numeroDeFila +'"> '
            + '<td id="pn'+ gon.numeroDeFila +'1">'+ $("#tds_tipo_de_documento_secundario_id :selected").text() +' </td> '
            + '<td id="pn'+ gon.numeroDeFila +'2">'+ $("#numero_doc_secundario").val() +' </td> '
            + '<td id="pn'+ gon.numeroDeFila +'3"> <input type="button" value="Quitar" class="quitar_document" id="quitar_doc"> </td>'            
            + '<td id="pn'+ gon.numeroDeFila +'4"> <input type="hidden" name="documento_secundario_id" value=" '+ $("#tds_tipo_de_documento_secundario_id").val() +'">  </td> </tr>';            
                                                     
            gon.numeroDeFila++;          

            $(tableName + " tbody").append ( htmlToAppend );
            //bleRow.appendTo(tableName);            
          }
          else
          {alert("Hay campos vacios en el documento\n")}
      });

      //$("#quitar_doc").click(function() 
      $("#recepcion_documento").on('click', '.quitar_document', function() {            
        var par = $(this).parent().parent(); //tr
        par.remove();     
      });  
  });
