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

  width_map = 20
  height_map= 10
  $('.map .case').mouseover ->
    $case   = $(@)
    case_id = parseFloat($case.attr('id').substr(5))
    @current = case_id
    y = Math.floor(case_id / width_map)

    $('#case-' + (case_id - 40)).css('color', 'red')
    $('#case-' + (case_id + 40)).css('color', 'red')
    $('#case-' + (case_id - 1)).css('color', 'red')
    $('#case-' + (case_id + 1)).css('color', 'red')
    $('#case-' + (case_id - 20)).css('color', 'red')
    $('#case-' + (case_id + 20)).css('color', 'red')
    $('#test').text((case_id + 1))

    if y%2 == 0
      $('#case-' + (case_id - 21)).css('color', 'red')
      $('#case-' + (case_id + 19)).css('color', 'red')
    else
      $('#case-' + (case_id - 19)).css('color', 'red')
      $('#case-' + (case_id + 21)).css('color', 'red')

  .mouseout ->
    $('.case').css('color', 'white')