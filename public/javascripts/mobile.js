
$('#panic').live('pagebeforecreate',function(event){
  $('#issue').html($('#issue_1').html());
  
  $('.ui-slider').live('mouseup', function(){updateSlider();});
  $('.ui-slider').live('touchend', function(){updateSlider();});  
 
  function updateSlider()
  {
    index = $('#slider').attr('value');
    txt = $('#issue_'+index).html();
    $('#issue').html(txt);
  } 
});

$('#auth').live('pagebeforecreate',function(event){
  $("input[type='radio']").bind( "change", function(event, ui) {
    if(this.checked) {
      location.href = '/locale/'+this.value;
    }
  });
});
;