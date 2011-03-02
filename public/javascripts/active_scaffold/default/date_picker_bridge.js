jQuery(function($){
  if (typeof($.datepicker) === 'object') {
    $.datepicker.regional['ro'] = {"closeText":"Close","prevText":"Previous","nextText":"Next","currentText":"Today","monthNames":["Ianuarie","Februarie","Martie","Aprilie","Mai","Iunie","Iulie","August","Septembrie","Octombrie","Noiembrie","Decembrie"],"monthNamesShort":["Ian","Feb","Mar","Apr","Mai","Iun","Iul","Aug","Sep","Oct","Noi","Dec"],"dayNames":["Duminic\u0103","Luni","Mar\u021bi","Miercuri","Joi","Vineri","S\u00e2mbat\u0103"],"dayNamesShort":["Dum","Lun","Mar","Mie","Joi","Vin","S\u00e2m"],"dayNamesMin":["Dum","Lun","Mar","Mie","Joi","Vin","S\u00e2m"],"changeYear":true,"changeMonth":true,"dateFormat":"dd-mm-yy"};
    $.datepicker.setDefaults($.datepicker.regional['ro']);
  }
  if (typeof($.timepicker) === 'object') {
    $.timepicker.regional['ro'] = {"ampm":false,"hourText":"Ora","minuteText":"Minutul","secondText":"Secunda"};
    $.timepicker.setDefaults($.timepicker.regional['ro']);
  }
});
$(document).ready(function() {
  $('input.date_picker').live('focus', function(event) {
    var date_picker = $(this);
    if (typeof(date_picker.datepicker) == 'function') {
      if (!date_picker.hasClass('hasDatepicker')) {
        date_picker.datepicker();
        date_picker.trigger('focus');
      }
    }
    return true;
  });
  $('input.datetime_picker').live('focus', function(event) {
    var date_picker = $(this);
    if (typeof(date_picker.datetimepicker) == 'function') {
      if (!date_picker.hasClass('hasDatepicker')) {
        date_picker.datetimepicker();
        date_picker.trigger('focus');
      }
    }
    return true;
  });
});