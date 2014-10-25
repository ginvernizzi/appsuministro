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
  var counter = 1;
      $("#agregar_doc").click(function() 
      {        
        //Validacion
        if(true)
        {
          //alert("Only " + count + " Phone number allowed.");
          //return false;
        }

var htmlToAppend = '<tr id="pn'+ counter+'"> <td id="col'+ counter+'">'+ $("#tds_tipo_de_documento_secundario_id :selected").text() +' </td> <td id="col'+ counter+'">'+ $("#numero_doc_secundario").val() +' </td> <td id="col'+ counter+'">'+ $("#tds_tipo_de_documento_secundario_id").val() +' </td> </tr>';
                                                   
      $("#recepcion_documento").append ( htmlToAppend );
        newTableRow.appendTo("#recepcion_documento");
        counter++;
      });

      $("#quitar_doc").click(function() 
      {
        counter--;
        $("#pn" + counter-1).remove();
      });  
  });
