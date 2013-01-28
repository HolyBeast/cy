#
# Name    : jMap
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.jMap = ( element, options ) ->
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

      that = @
      @$element
      .html('<div class="inner" /><div class="action" />')
      .find('.action')
      .html('<img src="' + image_path('design/pixel.png') + '" usemap="#map" /><map name="map" />')

      $.get('/get/map.json', (data) ->
        xInit = Object.keys(data)[0]
        yInit = data[xInit][0]
        yEnd  = data[xInit][data[xInit].length]
        xEnd  = Object.keys(data)[Object.keys(data).length-1]

        widthMap = xEnd - xInit + 1
        xOffset  = (widthMap * 2 - 2) * 0.75 * that.settings['widthTile'] / 2
        pixelWidthMap  = xOffset * 2 + that.settings['widthTile']
        pixelHeightMap = that.settings['heightTile'] * widthMap

        $.each(data, (x, aY) ->
          x = parseFloat(x)
          $.each(aY, (k, y) ->
            left = (x - y) *  that.settings['widthTile'] * 0.75 + xOffset
            top  = (x + y) *  that.settings['heightTile'] / 2

            $('.inner')
            .append('<div id="case-' + x + '-' + y + '" class="case" />')
            .css({
              left: (556 - pixelWidthMap) / 2,
              top: (396 - pixelHeightMap) / 2
            })
            
            $('#case-' + x + '-' + y)
            .css({
              left: left,
              top: top
            })

            $('.action')
            .css({
              left: (556 - pixelWidthMap) / 2,
              top: (396 - pixelHeightMap) / 2,
              width: (pixelWidthMap),
              height: (pixelHeightMap)
            })
            .find('map')
            .append('<area id="area-' + x + '-' + y + '" shape="polygon" href="#" />')

            $('#area-' + x + '-' + y)
            .attr({
              coords: 
                (left + that.settings['widthTile'] * 0.25) + ', ' + 
                (top) + ', ' +
                (left + that.settings['widthTile'] * 0.75) + ', ' +
                (top) + ', ' +
                (left + that.settings['widthTile']) + ', ' +
                (top + that.settings['heightTile'] / 2) + ', ' +
                (left + that.settings['widthTile'] * 0.75) + ', ' +
                (top + that.settings['heightTile']) + ', ' +
                (left + that.settings['widthTile'] * 0.25) + ', ' +
                (top + that.settings['heightTile']) + ', ' +
                (left) + ', ' +
                (top + that.settings['heightTile'] / 2)
            })
          )
        )
      
        $('.map area')
        .mouseover ->
          $case  = $(@)
          caseCoord = $case.attr('id').split('-')
          @currentX = parseFloat(caseCoord[1])
          @currentY = parseFloat(caseCoord[2])

          $('#case-' + (@currentX - 1) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY + 1) +
          ', #case-' + (@currentX - 1) + '-' + (@currentY) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY) +
          ', #case-' + (@currentX) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX) + '-' + (@currentY + 1)) .text('X')

        .mouseout ->
          $('#case-' + (@currentX - 1) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY + 1) +
          ', #case-' + (@currentX - 1) + '-' + (@currentY) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY) +
          ', #case-' + (@currentX) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX) + '-' + (@currentY + 1)) .text('')
      )
  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jMap::defaults =
  heightTile: 26
  widthTile: 48
  callback: -> 

$.fn.jMap = (options) ->
  @each ->
    if $(@).data('jMap') is undefined
      plugin = new $.jMap(@, options)
      $(@).data('jMap', plugin)