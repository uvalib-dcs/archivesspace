$(function () {

  var padding = 4;

  var pad_number = function (number, padding) {
    var s = ('' + number);

    var padding_needed = (padding - s.length)

    if (padding_needed > 0) {
      s = (new Array(padding_needed + 1).join("0") + s);
    }

    return s;
  };


  var generate_accession_id = function () {
    $.ajax({
      url: APP_PATH + "plugins/generate_accession_identifier/generate",
      data: {},
      type: "POST",
      success: function(identifier) {
        $('#accession_id_0_').val(identifier.org_code);
        $('#accession_id_1_').val(identifier.year);
        $('#accession_id_2_').val(pad_number(identifier.number, padding));
        $('#accession_id_1_').enable();
        $('#accession_id_2_').enable();
      },
    })
  };

  
 
  var identifier_is_blank = function () {
    for (var i = 0; i < 4; i++) {
      if ($("#accession_id_" + i + "_").val() !== "") {
        return false;
      }
    }

    return true;
  };


  var use_default_values = function () {
      return $.ajax( { 
          url: APP_PATH + "plugins/generate_accession_identifier/default_values",
          type: "GET", async: false, 
          success: function(val) { use_default_values = val; },
      }).responseText == "true" ;
  };


  if (identifier_is_blank() && use_default_values() ) {
    generate_accession_id();
  }

})

