$(document).on("ready page:load", function() {

	$( "#bien_de_consumo_viejo" ).focus(function() {
		if( $('#clase_seleccionada_id').val() == null || $('#clase_seleccionada_id').val() == "" )	
		{ 
			$('bien_de_consumo_viejo').prop('disabled', true);
			alert("Debe seleccionar la Clase del item a buscar") 
		}
		else
		{
			$('bien_de_consumo_viejo').prop('enabled', true);		
		}
	});

	$( "#bien_de_consumo_nuevo" ).focus(function() {
		if( $('#clase_seleccionada_nueva_id').val() == null || $('#clase_seleccionada_nueva_id').val() == "" )	
		{ 
			$('bien_de_consumo_nuevo').prop('disabled', true);
			alert("Debe seleccionar la Clase del item a buscar") 
		}
		else
		{
			$('bien_de_consumo_nuevo').prop('enabled', true);		
		}
	});

	$("#bien_de_consumo_viejo").autocomplete({	 
		source: function(request, response ) {	
			autocompletar_item(request, response, $("#clase_seleccionada_id").val(), "/reemplazo_bdc/autocomplete_bien_de_consumo_dado_de_baja_nombre_by_clase");
	    },
    	minLength: 2,
		select: function(event, ui) {
			traer_item_por_clase($("#clase_seleccionada_id").val(), ui.item.value,'#codigo_viejo','#bien_de_consumo_viejo_id', "/reemplazo_bdc/traer_item_dado_de_baja_por_nombre")			
		}
	});  

	$("#bien_de_consumo_nuevo").autocomplete({	 
		source: function(request, response ) {	
			autocompletar_item(request, response, $("#clase_seleccionada_nueva_id").val(), "/reemplazo_bdc/autocomplete_bien_de_consumo_dado_de_alta_nombre_by_clase");
	    },
    	minLength: 2,
		select: function(event, ui) {
			traer_item_por_clase($("#clase_seleccionada_nueva_id").val(), ui.item.value,'#codigo_nuevo','#bien_de_consumo_nuevo_id', "/reemplazo_bdc/traer_item_dado_de_alta_por_nombre")			
		}
	});   

	function autocompletar_item(request, response, clase_id, urlString)
	{

		$.ajax({
			url: urlString,
			dataType: "json",
			data: {
			term: request.term,
			clase_id: clase_id,		               
			},
			success: function( data ) 
			{
		 		function hasMatch(s) {
		            return s.toLowerCase().indexOf(request.term.toLowerCase())!==-1;
		        }
		        var i, l, obj, matches = [];

		        if (request.term==="") {
				    response([]);
		            return;
		        }
		           
		        for  (i = 0, l = data.length; i<l; i++) {
		            obj = data[i];
		            if (hasMatch(obj.nombre) || hasMatch(obj.codigo)) {
		                matches.push(obj.nombre +":"+obj.codigo);
		            }
		        }
		        response(matches);
				/////////////
			},          
		})
	}
  
 
	function traer_item_por_clase(clase_id, nombre_y_codigo, campo_codigo, campo_bien_id, urlString)
	{
		$.ajax({
			url: urlString,
			type: "post",
			dataType: "json",
			data: {
			nombre_de_item: nombre_y_codigo.split(":")[0],
			codigo_de_item: nombre_y_codigo.split(":")[1],
			clase_id: clase_id,		               
			},
			success: function( data ) 
			{					
				if(data != null)	
				{
					$(campo_codigo).val(data[0].codigo); 
					$(campo_bien_id).val(data[0].id);
				}					
			},          
		})			
  	};

  	$("#obtener_bien_de_consumo_viejo").on('click', function() {   
  	  	if ( ($('#clase_seleccionada_id').val() != null && $('#clase_seleccionada_id').val() != "") && 
  	  		 ($('#codigo_viejo').val() != "")) 
  	  	{ obtener_bien_de_consumo($("#clase_seleccionada_id").val(), $("#codigo_viejo").val(), '#bien_de_consumo_viejo', '#bien_de_consumo_viejo_id', "/reemplazo_bdc/traer_bien_dado_de_baja_por_clase"); }
  		else
  		{ alert("Debe completar la Clase y el codigo del item a buscar") }
  	})

    
   	$("#obtener_bien_de_consumo_nuevo").on('click', function() {   
  	  	if ( ($('#clase_seleccionada_nueva_id').val() != null && $('#clase_seleccionada_nueva_id').val() != "") && 
  	  		 ($('#codigo_nuevo').val() != "")) 
  	  	{ obtener_bien_de_consumo($("#clase_seleccionada_nueva_id").val(), $("#codigo_nuevo").val(), '#bien_de_consumo_nuevo', '#bien_de_consumo_nuevo_id', "/reemplazo_bdc/traer_bien_dado_de_alta_por_clase"); }
  		else
  		{ alert("Debe completar la Clase y el codigo del item a buscar") }
  	})


  	function obtener_bien_de_consumo(clase_id, codigo, campo_bien_de_consumo_nombre, campo_bien_de_consumo_id, utlString )
  	{     	
	    $.ajax({
			type: "post",
			dataType: "json",
			url: utlString,  
			data: { clase_id: clase_id, codigo: codigo },        
			success: function(data){  
				if(data != null)				
				{  
					$(campo_bien_de_consumo_nombre).val(data.nombre); 
					$(campo_bien_de_consumo_id).val(data.id); 
				}	
			    else
				{ 	alert("No se encontro el item") }
				},
			error: function (request, status, error) 
				{             
					alert("Ha ocurrido un error");
				}
	    });       
  	};

  	$('#crear_reemplazo_item').on('click', function(){
		    $.ajax({
				type: "post",
				dataType: "json",
				//dataType: "html",
				url: "/reemplazo_bdc/crear_reemplazo_de_bien_manual",  
				data: { 
						clase_vieja_id: $("#clase_seleccionada_id").val(), 
						clase_nueva_id: $("#clase_seleccionada_nueva_id").val(), 
						bien_de_consumo_viejo_id: $("#bien_de_consumo_viejo_id").val(), 
						bien_de_consumo_nuevo_id: $("#bien_de_consumo_nuevo_id").val() 
				},        
				success: function(data){
						{ alert("Se asociaron los items exitosamente"); }
				},
				error: function (request, status, error){             						
						//$("#container_total").html(request.responseText);
						//$("#_form_reemplazo_bdc").html(request.responseText);
						//var container = jQuery(request.responseText).find('#container').html()						 
                        //$('#container').html(container);

                        var container = jQuery(request.responseText).find('#error_explanation').html()
                        $('#error_explanation').html(container);
                        //eval(data);
				}
		    });       
    }); 
    
}); //FIN	

							// <div id="form_reemplazo_bdc">  
							//     <% if @reemplazo_bdc.errors.any? %>
							//       <div id="error_explanation">     
							//       </div>     
							//     <% end %>  
							// </div>     



  