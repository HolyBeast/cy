#
# Name    : jSelect
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.jSelect = ( element, options ) ->
  # current state
  state = ''

  # plugin settings
  @settings = {}

  # jQuery version of DOM element attached to the plugin
  @$element = $ element

  # set current state
  @setState = ( _state ) -> state = _state

  #get current state
  @getState = -> state

  # get particular plugin setting
  @getSetting = ( key ) ->
    @settings[ key ]

  # call one of the plugin setting functions
  @callSettingFunction = ( name, args = [] ) ->
    @settings[name].apply( this, args )
  
  #
  # public methods
  #
  @init = ->
    @$element
    .wrap('<div class="select" />')
    .before('<span>' + @$element.find('option:selected').text() + '</span>')

    @$element
    .css('opacity', '0')
    .change =>
      @$element.prev().text(@$element.find('option:selected').text())
    .focus =>
      @$element.parent().addClass('focus')
    .blur =>
      @$element.parent().removeClass('focus')

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jSelect::defaults =
    callback: ->          # callback description

$.fn.jSelect = ( options ) ->
  this.each ->
    if $(this).data( 'jSelect' ) is undefined
      plugin = new $.jSelect( this, options )
      $(this).data( 'jSelect', plugin )