//$(document).ready(ready);
//$(document).on('page:load', ready)

$(document).on("ready page:load", function() {
   var currentDate = new Date();
  $('#recepcion_de_bien_de_consumo_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });

  $("#recepcion_de_bien_de_consumo_fecha").datepicker("setDate", currentDate);
});


/////////////////// Vista nueva recepcion. Agrear y quitar Documentos ///////////////////  
  $(document).on("ready page:load", function() {
      $("#recepcion_de_bien_de_consumo_documento_principal").inputmask("9999-99999999", { clearMaskOnLostFocus: true, placeholder: '0' })      
      $('#numero_doc_secundario').attr('readonly', true)            

      var tableName = "#recepcion_documento";
      var table = document.getElementById("recepcion_documento");  

      $("#agregar_doc").click(function() 
      {               
          if($('#numero_doc_secundario').val() != "" &&  $("#tds_tipo_de_documento_secundario_id").val()  != "")
          {                       
            var htmlToAppend = '<tr id="pn'+ gon.numeroDeFila +'"> '
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#tds_tipo_de_documento_secundario_id :selected").text() +' </td>'
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#numero_doc_secundario").val() +' </td> '
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="button" value="Quitar" class="quitar_document" id="quitar_doc"> </td>'            
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_numero_doc_secundario]" value="'+$("#numero_doc_secundario").val()+'">  </td>'
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_tipo_de_documento_secundario_id]" value="'+$("#tds_tipo_de_documento_secundario_id").val()+'">  </td> </tr>';            
            
            $('#numero_doc_secundario').val("")     

            gon.numeroDeFila++;          

            $(tableName + " tbody").append ( htmlToAppend );                                    
          }
          else            
          { alert("Hay campos vacios. No se puede agregar documento\n") }
      });

      
      $("#recepcion_documento").on('click', '.quitar_document', function() {            
          var par = $(this).parent().parent(); 
          par.remove();     
      });  
                  
      //Evento al cambiar de item en el combo de documento principal
      $('#tdp_tipo_de_documento_id').change(function() {
            var urlToSubmit = ""
            //Habria que traer los tipos de documento
            if($(this).val() == 1) 
              {
              $("#recepcion_de_bien_de_consumo_documento_principal").inputmask("9999-99999999", { clearMaskOnLostFocus: true, placeholder: '0'});
              $('#recepcion_de_bien_de_consumo_documento_principal').attr('readonly', false);
              }            
            if($(this).val() == 2) 
            {   $("#recepcion_de_bien_de_consumo_documento_principal").inputmask("999-9999", { clearMaskOnLostFocus: true, placeholder: '0'});
                $('#recepcion_de_bien_de_consumo_documento_principal').attr('readonly', false); 
            }              
            if($(this).val() == "") 
              {$('#recepcion_de_bien_de_consumo_documento_principal').attr('readonly', true) };  
      });

      //Evento al cambiar de item en el combo de documento secundario
      $('#tds_tipo_de_documento_secundario_id').change(function() {
            var urlToSubmit = ""
            //Habria que traer los tipos de documento
            if($(this).val() == 1)
              {
                $("#numero_doc_secundario").inputmask("9999-99999999", {  clearMaskOnLostFocus: true , placeholder: '0'});
                $("#numero_doc_secundario").attr('readonly', false);
              }                         
            if($(this).val() == 2)
              {
                $("#numero_doc_secundario").inputmask("999-9999", { clearMaskOnLostFocus: true, placeholder: '0'} );
                $("#numero_doc_secundario").attr('readonly', false);
              }   

            if($(this).val() == "") {$('#numero_doc_secundario').attr('readonly', true);}  
      });
      

      $('#recepcion_de_bien_de_consumo_estado').change(function() {
            var urlToSubmit = ""
            //Habria que traer los tipos de documento            
            if($(this).val() != 2)              
              {  $( ".field_descripcion_provisoria" ).remove(); }
            else
              { 
                urlToSubmit = "/recepciones_de_bien_de_consumo/pegar_campo_descripcion_provisoria"               
                $.ajax({  
                url: urlToSubmit,
                type: "POST",
                data: { },
                success:function(result) 
                      {  $("#div_descripcion_provisoria").html(result) }
                });                        
              }      
      });                                           
  });
