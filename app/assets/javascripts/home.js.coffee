# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#clock').clock()
  $('#main form select').jSelect()
  $('.observator').jHint()

  $('form').each ->
    $(this).attr 'autocomplete', 'off'

  $('#user_hero_attributes_nation').change ->
    userRace = $('#user_hero_attributes_race')

    $.get('/get/races.json', { nation : $(@).val() }, (data) ->
      userRace.empty()
      $.each(data, (value, label) ->
        option = $("<option />").attr("value", value).text(label)
        
        userRace
        .append(option)
        .change()
      )
    )