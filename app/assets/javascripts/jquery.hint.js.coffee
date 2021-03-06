#
# Name    : jHint
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

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
        hint  = $(@).closest('.field').find('span.hint').html()
        error = $(@).closest('.field').find('span.error').html()

        hint = '' if hint == undefined
        hint = hint + '<br /><br />' if hint != '' && error != undefined
        hint = hint + '<span style="color: #c22">' + error + '</span>' if error != undefined

        if hint != ''
          clearTimeout that.onblur if that.onblur?
        
          if that.current != @id

              that.$element
              .find('p')
              .attr('class', 'hint-' + @id)
              .fadeOut 'fast', ->
                originalHeight = $(@).height()

                $(@)
                .css({ opacity: '0', display: 'block'})
                .html(hint)

                newHeight = $(@).height()

                $(@)
                .css('height', originalHeight)
                .animate {height: newHeight}, 'fast', ->
                  $(@).css({height: 'auto', display: 'none', opacity: '1'}).fadeIn('fast')

              that.current = @id

      .blur ->

        if that.current != 'original'
          clearTimeout that.onblur if that.onblur?

          that.onblur = setTimeout ->
            that.$element
            .find('p')
            .attr('class', 'hint-original')
            .fadeOut 'fast', ->
              originalHeight = $(@).height()

              $(@)
              .css({ opacity: '0', display: 'block'})
              .html(that.$element.attr('original-hint'))

              newHeight = $(@).height()

              $(@)
              .css('height', originalHeight)
              .animate {height: newHeight}, 'fast', ->
                $(@).css({height: 'auto', display: 'none', opacity: '1'}).fadeIn('fast')

            that.current = 'original'
          , 3000

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jHint::defaults =
  target: 'input[type!=submit], select'
  callback: -> 

$.fn.jHint = (options) ->
  @each ->
    if $(@).data('jHint') is undefined
      plugin = new $.jHint(@, options)
      $(@).data('jHint', plugin)