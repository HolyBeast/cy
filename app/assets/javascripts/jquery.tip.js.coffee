#
# Name    : jTip
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.jTip = ( element, options ) ->
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
      @$element
      .attr('original-title', @$element.attr('title'))
      .attr('title', '')
      .focus =>
        @tip = @$element.attr 'original-title' # Texte de l'info-bulle

        $('body').append("<div id='tooltip'><span class='text'>#{@tip}</span></div>")
              
        @tooltip       = $ '#tooltip'              # Nouvelle instanciation
        @widthBody     = document.body.clientWidth # Largeur de la page
        @widthTooltip  = @tooltip.width()          # Largeur de l'info-bulle
        @widthElement  = @$element.outerWidth()    # Largeur de l'élément renseigné
        @offsetElement = @$element.offset()

        x = @offsetElement.left + @settings.xOffset + @widthElement
        y = @offsetElement.top + @settings.yOffset

        if x + @widthTooltip + 2 > @widthBody # Si l'info-bulle dépasse de l'écran 
          x = @offsetElement.left - @widthTooltip - @settings.xOffset

        @tooltip.css # Assignation de la position de la toolbox
          left: x + 'px',
          top : y + 'px'  
        .delay(300)
        .fadeIn 'fast'

      .blur =>
        @tooltip.remove() # Nettoyage de l'info-bulle
        
  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jTip::defaults =
  xOffset: 15,
  yOffset: 0,
  callback: ->          # callback description

$.fn.jTip = ( options ) ->
  this.each ->
    if $(this).data( 'jTip' ) is undefined
      plugin = new $.jTip( this, options )
      $(this).data( 'jTip', plugin )