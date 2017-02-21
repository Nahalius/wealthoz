$(document).ready ->
  $("[data-behaviour~=datepicker]").datepicker(
    weekStart: 1,
    autoclose: true,
    format:'yyyy-mm-dd' ,
    todayHighlight: true
  )
