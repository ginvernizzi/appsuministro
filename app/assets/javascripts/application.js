// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.all
//= require autocomplete-rails
//= require bootstrap
//= require bootstrap.js
//= require bootstrap-datepicker
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.numeric.extensions
//= require jquery.inputmask.date.extensions
//= require turbolinks
//= require_tree 


$(document).on("ready page:load", function() {

  (function() {
    jQuery(function() {
      var bienes, llenarBienes;
      llenarBienes = function(bienes) {
        var inciso, options;
        inciso = $('#categoria_clase_id :selected').text();
        options = $(bienes).filter("optgroup[label='" + inciso + "']").html();
        if (options) {
          $('#categoria_bien_de_consumo_id').html('<option value="">seleccione...</option>');
          return $('#categoria_bien_de_consumo_id').append(options);
        } 
        else {
          return $('#categoria_bien_de_consumo_id').empty();
        }
      };
      bienes = $('#categoria_bien_de_consumo_id').html();
      llenarBienes(bienes);
      return $('#categoria_clase_id').change(function() {
        return llenarBienes(bienes);
      });
    }); 
  }).call(this);

  $("#traer_vista_de_bien_de_consumo").click(function() {        
    var categoria = "Bien_de_consumo"
    var id = $("#categoria_clase_id").val();

    if($('#categoria_clase_id').val() != null && $('#categoria_clase_id').val().length > 0)
    {
      $.ajax({
        type: "get",
        dataType: "json",
        url: "/bienes_de_consumo/traer_vista_de_categoria",        
        data: { categoria: categoria, id: id },
        success: function(data){            
            $('#form_categoria').html(data)
        }
      });         
    }
    else
    {
      alert("Debe seleccionar la categoria anterior primero");
    } 
  }); 
});



