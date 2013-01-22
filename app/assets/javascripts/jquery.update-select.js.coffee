#
# Name    : jUpdateSelect
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.jUpdateSelect = ( element, options ) ->
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
    if @$element.length && $(@settings['target']).length
      @$targetSelect = $(@settings['target'])

      that = @

      @$element
      .change ->
        $.get(that.settings['url'], { value : $(@).val() }, (data) ->
          that.$targetSelect.empty()
          $.each(data, (value, label) ->
            option = $("<option />").attr("value", value).text(label)
            
            that.$targetSelect
            .append(option)
          )
          that.$targetSelect.change()
        )

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jUpdateSelect::defaults =
  url: 'URL ABSENTE'
  target: null
  callback: ->          # callback description

$.fn.jUpdateSelect = ( options ) ->
  this.each ->
    if $(this).data( 'jUpdateSelect' ) is undefined
      plugin = new $.jUpdateSelect( this, options )
      $(this).data( 'jUpdateSelect', plugin )