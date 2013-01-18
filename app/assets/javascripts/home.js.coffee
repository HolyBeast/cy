# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#clock').clock()
  $('#main form select').jSelect()
  $('.observator').jHint()

  if $.browser.webkit
    $('input[type=text], input[type=password]').each ->
      $(this).attr 'autocomplete', 'off'