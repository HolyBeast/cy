#
# Name    : jHelp
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.fn.typewriter = ->
  @each ->
    $ele = $(this)
    str = $.trim($ele.html())
    progress = 0
    $ele.text ""
    timer = setInterval(->
      clearInterval timer  if progress > str.length or $ele.length < 1
      $ele.html str.substring(0, progress++)
    , 25)

  this


$.jHelp = ( element, options ) ->
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
    @settings = $.extend( {}, @defaults, options )
    @callSettingFunction( 'callback', [ @$element, @getSetting( 'message' ) ] ) 

    @setState 'ready'
    
    # Check the existence of the element
    if @$element.length
      @$target = $ @settings.target
      @counter = 0;

      @$target
      .focus ->

        if $(this).attr('title') != ''
          blabla = $.trim $(this).attr 'title'

          $(this)
          .attr('original-title', blabla)
          .attr('title', '')
        else
          blabla = $(this).attr 'original-title'

        if !_this.$element.attr('original-blabla')?
          _this.$element.attr('original-blabla', _this.$element.html()).empty()

        if _this.current != this.id
          clearTimeout _this.onblur if _this.onblur?
          $('.observator .blabla-' + _this.current).remove()
          _this.current = this.id
          _this.$element.append('<p class="blabla-' + _this.current + '"></p>')
          $('.observator .blabla-' + _this.current).html(blabla).typewriter()

      .blur =>
        clearTimeout _this.onblur if _this.onblur?
        _this.onblur = setTimeout ->
          $('.observator .blabla-' + _this.current).remove()
          _this.current = 'original'
          _this.$element.append('<p class="blabla-original"></p>')
          $('.observator .blabla-original').html($('.observator').attr('original-blabla')).typewriter() # Nettoyage de l'info-bulle
        , 5000
  
  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jHelp::defaults =
  speed: 'fast',
  target: 'input[title], select[title]'
  callback: -> 

$.fn.jHelp = ( options ) ->
  this.each ->
    if $(this).data( 'jHelp' ) is undefined
      plugin = new $.jHelp( this, options )
      $(this).data( 'jHelp', plugin )