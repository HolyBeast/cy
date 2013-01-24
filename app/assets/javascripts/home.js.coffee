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

  width_map = 15

  $('#proto2 area').mouseover ->
    $case   = $(@)
    case_id = parseFloat($case.attr('id').substr(12))
    @current = case_id
    y = Math.floor(case_id / width_map)


    $('#test').text(y)
    $('#proto2-case-' + (case_id - 1) +
    ', #proto2-case-' + (case_id + 1) +
    ', #proto2-case-' + (case_id - width_map - 1) +
    ', #proto2-case-' + (case_id + width_map + 1) +
    ', #proto2-case-' + (case_id - width_map) +
    ', #proto2-case-' + (case_id + width_map)) .text('X')

  .mouseout ->
    $('#proto2 .case').text('')