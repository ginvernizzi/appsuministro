 $(document).ready(function(){
  $('#recepcion_de_bien_de_consumo_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,
    //setDate: currentDate,
    format: 'dd/mm/yyyy'
  });
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
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#tds_tipo_de_documento_secundario_id :selected").text() +' </td>'
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#numero_doc_secundario").val() +' </td> '
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="button" value="Quitar" class="quitar_document" id="quitar_doc"> </td>'            
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_numero_doc_secundario]" value="'+$("#numero_doc_secundario").val()+'">  </td>'
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_tipo_de_documento_secundario_id]" value="'+$("#tds_tipo_de_documento_secundario_id").val()+'">  </td> </tr>';            
                                                     
            gon.numeroDeFila++;          

            $(tableName + " tbody").append ( htmlToAppend );
            //bleRow.appendTo(tableName);            
          }
          else
          {alert("Debe completar los campos de documento secundario\n")}
      });

      //$("#quitar_doc").click(function() 
      $("#recepcion_documento").on('clic k', '.quitar_document', function() {            
        var par = $(this).parent().parent(); //tr
        par.remove();     
      });  
   
      $("#numero_doc_secundario").inputmask("9999-99999999")
      $("#numero_doc_principal").inputmask("9999-99999999")

      // function validarNumeroDocumento(numero) { 
      // var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      // return re.test(numero);
      // } 
  });
