# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#clock').clock()
  $('.observator').jHint()
  $('#main form select').jSelect()
  $('#user_hero_attributes_nation')
  .jUpdateSelect {target: '#user_hero_attributes_race', url: '/get/races.json'}

  $('form').each ->
    $(this).attr 'autocomplete', 'off'