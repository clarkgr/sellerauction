$(function(){
  $('.timepicker').datetimepicker({
    dateFormat: 'yy-mm-dd',
    hour: new Date().getUTCHours(),
    minute: new Date().getUTCMinutes(),
    stepMinute: 5
  });
});
