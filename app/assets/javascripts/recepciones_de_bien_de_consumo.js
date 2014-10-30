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
      $('#numero_doc_principal').attr('disabled', true)
      $('#numero_doc_secundario').attr('disabled', true)      
      var tableName = "#recepcion_documento";
      var table = document.getElementById("recepcion_documento");  

      $("#agregar_doc").click(function() 
      {               
          if($('#numero_doc_secundario').val() != "" ||  $("#tds_tipo_de_documento_secundario_id").val()  != "")
          {                       
            var htmlToAppend = '<tr id="pn'+ gon.numeroDeFila +'"> '
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#tds_tipo_de_documento_secundario_id :selected").text() +' </td>'
            + '<td id="col'+ gon.numeroDeFila +'">'+ $("#numero_doc_secundario").val() +' </td> '
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="button" value="Quitar" class="quitar_document" id="quitar_doc"> </td>'            
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_numero_doc_secundario]" value="'+$("#numero_doc_secundario").val()+'">  </td>'
            + '<td id="col'+ gon.numeroDeFila +'"> <input type="hidden" name="ltds['+ gon.numeroDeFila +'_tipo_de_documento_secundario_id]" value="'+$("#tds_tipo_de_documento_secundario_id").val()+'">  </td> </tr>';            
                                                     
            gon.numeroDeFila++;          

            $(tableName + " tbody").append ( htmlToAppend );
            $('#numero_doc_secundario').val("")                   
          }
          else
          {alert("Hay campos vacios. No se puede agregar documento\n")}
      });

      
      $("#recepcion_documento").on('click', '.quitar_document', function() {            
          var par = $(this).parent().parent(); 
          par.remove();     
      });  
         
      $("#numero_doc_principal").inputmask("9999-99999999")      
      

      // function validarNumeroDocumento(numero) { 
      // var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      // return re.test(numero);
      // }
      $('#tdp_tipo_de_documento_id').change(function() {
            var urlToSubmit = ""
            //Habria que traer los tipos de documento
            if($(this).val() == 1) 
            {
               $("#numero_doc_principal").inputmask("9999-99999999");
               $('#numero_doc_principal').attr('disabled', false);
            }            
            if($(this).val() == 2) 
            {   $("#numero_doc_principal").inputmask("999-9999");
                $('#numero_doc_principal').attr('disabled', false);
            }              
            if($(this).val() == "") {$('#numero_doc_principal').attr('disabled', true);}  

      });

       $('#tds_tipo_de_documento_secundario_id').change(function() {
            var urlToSubmit = ""
            //Habria que traer los tipos de documento
            if($(this).val() == 1)
              {
                $("#numero_doc_secundario").inputmask("9999-99999999");
                $("#numero_doc_secundario").attr('disabled', false);
              }                         
            if($(this).val() == 2)
              {
                $("#numero_doc_secundario").inputmask("999-9999");
                $("#numero_doc_secundario").attr('disabled', false);
              }   

            if($(this).val() == "") {$('#numero_doc_secundario').attr('disabled', true);}  
      });


      /////////////////// Vista nueva recepcion. Agrear y quitar Bienes de consumo ///////////////////        
      $( "#costo" ).blur(function() {
           if($('#cantidad').val() != "" &&  $("#costo").val()  != "")                  
           $('#costoTotal').val(parseFloat($('#costo').val()) * parseInt($('#cantidad').val())); 
           else
           $('#costoTotal').val("");
           end           
      });      

      //$("#costo").inputmask("9999999.9999")    
      
      $("#traer_bien_de_consumo").click(function() {  
        var cod = $("#codigo").val();        
        $.ajax({
                url: "/recepciones_de_bien_de_consumo/obtener_nombre_de_bien_de_consumo",
                dataType: "json",
                //contentType: "application/json", no va, si no envias un json!!!
                type: "post",
                data: { codigo: cod },                
                success:function(data){                  
                  $("#nombre").val(data[0].nombre)                
                },
                error: function (request, status, error) {
                  alert("Bien de consumo inexistente");
                }
              });
      });
  });
