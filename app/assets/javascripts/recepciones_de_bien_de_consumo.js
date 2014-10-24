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
  var counter = 2;
      $("#agregar_doc").click(function() 
      {        
        //Validacion
        if(true)
        {
          //alert("Only " + count + " Phone number allowed.");
          //return false;
        }

    //var htmlToAppend = '<tr id="pn'+ counter +'"><th><select class="phone_no"> <option value="home">home</option> <option value="Business">Business</option> <option value="Business2">Business 2</option></select> </th><td><input type="text"/></td></tr>';      

    var htmlToAppend = '<tr id="pn'+ counter> +'"><th> <%= f.label :tipo_de_documento_secundario %><br /> <%= collection_select(:tds, "tipo_de_documento_secundario_id", @tipos_de_documento, "id", "nombre", :include_blank => "Seleccione un documento...") %> </th> <td> <%= f.label :numero %><br> <%= text_field_tag "numero_doc_secundario", params[:numero], id: "numero_doc_principal" %> </td> </tr>'
                                                   
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

