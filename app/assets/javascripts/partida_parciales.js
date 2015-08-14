$(document).on("ready page:load", function() {
  $('#partida_parcial_nombre').bind('railsAutocomplete.select', function(event, data){      
    $("#clase_partida_parcial_id").val(data.item.id);
  });
});
