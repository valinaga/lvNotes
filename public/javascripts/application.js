
$('#panic').live('pagebeforecreate',function(event){
  $('.ui-slider').live('mouseup', function(){updateSlider();});
  $('.ui-slider').live('touchend', function(){updateSlider();});  
 
  function updateSlider()
  {
    index = $('#slider').attr('value');
    txt = $('#select option[value="'+index+'"]')[0].text;
    $('#problem').html(txt);
  } 
});
