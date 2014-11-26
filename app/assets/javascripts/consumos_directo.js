$(document).on("ready page:load", function() {
   var currentDate = new Date();
  $('#consumo_directo_fecha').datepicker
  ({
    showOn: 'both',  
    autoclose: true,    
    format: 'dd/mm/yyyy',
    language: "es"
  });

  $("#consumo_directo_fecha").datepicker("setDate", currentDate);
});

