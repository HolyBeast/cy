#
# Name    : jClock
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.clock = ( element, options ) ->
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
  # private methods
  #
  parseTime = (timeToParse) =>
    timeParsed = timeToParse.match(/(\d+)/g)
    new Date(timeParsed[0], timeParsed[1] - 1, timeParsed[2], timeParsed[3], timeParsed[4], timeParsed[5]) # months are 0-based

  #
  # public methods
  #
  @init = ->
    @settings = $.extend( {}, @defaults, options )
    @callSettingFunction( 'callback', [ @$element, @getSetting( 'message' ) ] ) 

    @setState 'ready'
    
    # Check the existence of the element
    if @$element.length
      @parsedTime  = parseTime(@$element.text())
      @currentTime = new Date(@parsedTime)

      @tictac @currentTime, true

  @tictac = (time, first) ->
    hours   = if time.getHours()   < 10 then '0' + time.getHours()   else time.getHours()
    minutes = if time.getMinutes() < 10 then '0' + time.getMinutes() else time.getMinutes()
    seconds = if time.getSeconds() < 10 then '0' + time.getSeconds() else time.getSeconds()

    @$element.text hours + ':' + minutes if (seconds is '00' or first is true) and @settings.format is 'h:m'
    @$element.text hours + ':' + minutes + ':' + seconds if @settings.format is 'h:m:s'

    time.setSeconds time.getSeconds() + 1

    setTimeout (=> @tictac time), 1000

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.clock::defaults =
    format: 'h:m'
    callback: ->          # callback description

$.fn.clock = ( options ) ->
  this.each ->
    if $(this).data( 'clock' ) is undefined
      plugin = new $.clock( this, options )
      $(this).data( 'clock', plugin )