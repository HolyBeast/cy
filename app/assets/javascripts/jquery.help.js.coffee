#
# Name    : jHint
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.fn.typewriter = ->
  @each ->
    clearInterval this.timer if @timer?

    progress = 0
    $ele     = $(@)
    str      = $.trim($ele.html())
    
    $ele.empty()

    @timer = setInterval ->
      $ele.html str.substring(0, progress++)
    , 25

  this


$.jHint = ( element, options ) ->
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
      @current = 'original'
      @$target = $ @settings.target

      @$element
      .attr('original-hint', $.trim(@$element.html()))
      .wrapInner '<p class="hint-original" />'

      that = @

      @$target
      .focus ->
        
        if $(@).attr('title') != ''
          $(@)
          .attr('original-title', $.trim($(@).attr('title')))
          .attr 'title', ''

        blabla = $(@).attr 'original-title'

        if that.current != @id and blabla != ''
          
          clearTimeout that.onblur if that.onblur?

          that.$element
          .find('p')
          .attr('class', 'hint-' + @id)
          .html(blabla)
          .typewriter()

          that.current = @id

      .blur ->
        clearTimeout that.onblur if that.onblur?

        that.onblur = setTimeout ->
          that.$element
          .find('p')
          .attr('class', 'hint-original')
          .html(that.$element.attr('original-hint'))
          .typewriter()

          that.current = 'original'
        , 3000

      .change ->
        $(@).parent().focus()

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jHint::defaults =
  target: 'input[title], select'
  callback: -> 

$.fn.jHint = (options) ->
  @each ->
    if $(@).data('jHint') is undefined
      plugin = new $.jHint(@, options)
      $(@).data('jHint', plugin)