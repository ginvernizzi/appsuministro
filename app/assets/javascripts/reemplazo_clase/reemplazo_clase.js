$(document).on("ready page:load", function() {

	$( "#clase_vieja" ).focus(function() {
		if( $('#partida_parcial_seleccionada_vieja_id').val() == null || $('#partida_parcial_seleccionada_vieja_id').val() == "" )	
		{ 
			$('clase_vieja').prop('disabled', true);
			alert("Debe seleccionar la Partida Parcial de la Clase a buscar") 
		}
		else
		{
			$('clase_vieja').prop('enabled', true);		
		}
	});

	$( "#clase_nueva" ).focus(function() {
		if( $('#partida_parcial_seleccionada_nueva_id').val() == null || $('#partida_parcial_seleccionada_nueva_id').val() == "" )	
		{ 
			$('clase_nueva').prop('disabled', true);
			alert("Debe seleccionar la Partida Parcial de la Clase a buscar") 
		}
		else
		{
			$('clase_nueva').prop('enabled', true);		
		}
	});

	$("#clase_vieja").autocomplete({	 
		source: function(request, response ) {	
			autocompletar_clase(request, response, $("#partida_parcial_seleccionada_id").val(), "/reemplazo_clase/autocomplete_clase_dada_de_baja_nombre_por_partida_parcial");
	    },
    	minLength: 2,
		select: function(event, ui) {
			traer_clase_por_p_parcial($("#partida_parcial_seleccionada_id").val(), ui.item.value,'#codigo_viejo','#clase_vieja_id', "/reemplazo_clase/traer_clase_dada_de_baja_por_nombre")			
		}
	});  

	$("#clase_nueva").autocomplete({	 
		source: function(request, response ) {	
			autocompletar_clase(request, response, $("#partida_parcial_seleccionada_nueva_id").val(), "/reemplazo_clase/autocomplete_clase_dada_de_alta_nombre_por_partida_parcial");
	    },
    	minLength: 2,
		select: function(event, ui) {
			traer_clase_por_p_parcial($("#partida_parcial_seleccionada_nueva_id").val(), ui.item.value,'#codigo_nuevo','#clase_nueva_id', "/reemplazo_clase/traer_clase_dada_de_alta_por_nombre")			
		}
	});   

	function autocompletar_clase(request, response, partida_parcial_id, urlString)
	{

		$.ajax({
			url: urlString,
			dataType: "json",
			data: {
			term: request.term,
			partida_parcial_id: partida_parcial_id,		               
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
  
 
	function traer_clase_por_p_parcial(partida_parcial_id, nombre_y_codigo, campo_codigo, campo_clase_id, urlString)
	{
		$.ajax({
			url: urlString,
			type: "post",
			dataType: "json",
			data: {
			nombre_de_clase: nombre_y_codigo.split(":")[0],
			codigo_de_clase: nombre_y_codigo.split(":")[1],
			partida_parcial_id: partida_parcial_id,		               
			},
			success: function( data ) 
			{					
				if(data != null)	
				{
					$(campo_codigo).val(data[0].codigo); 
					$(campo_clase_id).val(data[0].id);
				}					
			},          
		})			
  	};

  	$("#obtener_clase_vieja").on('click', function() {   
  	  	if ( ($('#partida_parcial_seleccionada_id').val() != null && $('#partida_parcial_seleccionada_id').val() != "") && 
  	  		 ($('#codigo_viejo').val() != "")) 
  	  	{ obtener_clase($("#partida_parcial_seleccionada_id").val(), $("#codigo_viejo").val(), '#clase_vieja', '#clase_vieja_id', "/reemplazo_clase/traer_clase_dada_de_baja_por_partida_parcial"); }
  		else
  		{ alert("Debe completar la Partida Parcial y el codigo de la clase a buscar") }
  	})

    
   	$("#obtener_clase_nueva").on('click', function() {   
  	  	if ( ($('#partida_parcial_seleccionada_nueva_id').val() != null && $('#partida_parcial_seleccionada_nueva_id').val() != "") && 
  	  		 ($('#codigo_nuevo').val() != "")) 
  	  	{ obtener_clase($("#partida_parcial_seleccionada_nueva_id").val(), $("#codigo_nuevo").val(), '#clase_nueva', '#clase_nueva_id', "/reemplazo_clase/traer_clase_dada_de_alta_por_partida_parcial"); }
  		else
  		{ alert("Debe completar la Partida Parcial y el codigo de la clase a buscar") }
  	})


  	function obtener_clase(partida_parcial_id, codigo, campo_clase_nombre, campo_clase_id, utlString )
  	{     	
	    $.ajax({
			type: "post",
			dataType: "json",
			url: utlString,  
			data: { partida_parcial_id: partida_parcial_id, codigo: codigo },        
			success: function(data){  
				if(data != null)				
				{  
					$(campo_clase_nombre).val(data.nombre); 
					$(campo_clase_id).val(data.id); 
				}	
			    else
				{ 	alert("No se encontro la clase") }
				},
			error: function (request, status, error) 
				{             
					alert("Ha ocurrido un error");
				}
	    });       
  	};

  	$('#crear_reemplazo').on('click', function(){
		    $.ajax({
				type: "post",
				dataType: "json",
				//dataType: "html",
				url: "/reemplazo_clase/crear_reemplazo_de_clase_manual",  
				data: { 
						clase_vieja_id: $("#partida_parcial_seleccionada_vieja_id").val(), 
						clase_nueva_id: $("#partida_parcial_seleccionada_nueva_id").val(), 
						clase_vieja_id: $("#clase_vieja_id").val(), 
						clase_nueva_id: $("#clase_nueva_id").val() 
				},        
				success: function(data){  			
						{ alert("Se asociaron las clases exitosamente"); }
				},
				error: function (request, status, error){             						
						//$("#nueva_asociacion_item_dado_de_baja").html(request.responseText);
						$("#form_reemplazo_clase").html(request.responseText);
						
				}
		    });       
    }); 

}); //FIN	



  