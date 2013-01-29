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
        border = true
        size   = 9
        specialSize = if border then size++ else size
        extendedSize = specialSize * 2

        xOffset         = (extendedSize * 2 - 2) * 0.75 * that.settings['widthTile'] / 2
        pixelWidthMap   = xOffset * 2 + that.settings['widthTile']
        pixelHeightMap  = that.settings['heightTile'] *(extendedSize + 1)
        widthContainer  = that.$element.width()
        heightContainer = that.$element.height()

        for x in [0..extendedSize]
          for y in [0..extendedSize]

            if Math.abs(y - x) <= specialSize
              xDisplay = if border then x - 1 else x
              yDisplay = if border then y - 1 else y

              left = (x - y) *  that.settings['widthTile'] * 0.75 + xOffset
              top  = (x + y) *  that.settings['heightTile'] / 2

              $('.inner')
              .append('<div id="case-' + xDisplay + '-' + yDisplay + '" class="case" />')
              .css({
                left: (widthContainer - pixelWidthMap) / 2,
                top: (heightContainer - pixelHeightMap) / 2
              })

              $('#case-' + xDisplay + '-' + yDisplay)
              .css({
                left: left,
                top: top
              })

              $('.action')
              .css({
                left: (widthContainer - pixelWidthMap) / 2,
                top: (heightContainer - pixelHeightMap) / 2
                width: (pixelWidthMap),
                height: (pixelHeightMap)
              })
              .find('map')
              .append('<area id="area-' + xDisplay + '-' + yDisplay + '" shape="polygon" href="#" />')

              $('#area-' + xDisplay + '-' + yDisplay)
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

              if border
                if x == 0 || y == 0 || x == extendedSize || y == extendedSize || Math.abs(x - y) == specialSize
                  $('#case-' + xDisplay + '-' + yDisplay).addClass(that.settings['borderClass']).attr('id', '').text('')
                  $('#area-' + xDisplay + '-' + yDisplay).removeAttr('href', 'id')
        
        $('.map').append('<input class="focus-map" />')
        $('.focus-map')
        .css({opacity: '0', marginLeft: '-9999px'})
        .focus ->
          $('.case.border').addClass('focus')
        .blur ->
          $('.case.border').removeClass('focus')

        $('.map area')
        .click (e) ->
          e.preventDefault()
          $('.focus-map').focus()

        $('.map area[href]')
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

          distanceX  = Math.abs(@currentX - (size - 2))
          distanceY  = Math.abs(@currentY - (size - 2))
          distanceXY = Math.abs(@currentX - @currentY)
          distance   = Math.max(distanceX, distanceY, distanceXY)
          specialSize = if border then size - 3 else size

          direction = ''
          if @currentX <= 1 and @currentY <= 1
            direction += 'N'
          else if @currentX <= 1
            direction += 'NW'
          else if @currentY <= 1
            direction += 'NE'
          else if @currentX > specialSize * 2 and @currentY > specialSize * 2
            direction += 'S'
          else if @currentY > specialSize * 2
            direction += 'SW'
          else if @currentX > specialSize * 2
            direction += 'SE'
          else if Math.abs(@currentX - @currentY) >= specialSize and @currentX > @currentY
            direction += 'E'
          else if Math.abs(@currentX - @currentY) >= specialSize and @currentX < @currentY
            direction += 'W'
          else
            direction = 'Non'

          speed = if distance == 8 then 2 else 1
          $('#slide').text(direction)
          $('#slide-speed').text(speed)
          $('#distance').text(distance)
          $('#mouse-x').text(@currentX)
          $('#mouse-y').text(@currentY)

        .mouseout ->
          $('#case-' + (@currentX - 1) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY + 1) +
          ', #case-' + (@currentX - 1) + '-' + (@currentY) +
          ', #case-' + (@currentX + 1) + '-' + (@currentY) +
          ', #case-' + (@currentX) + '-' + (@currentY - 1) +
          ', #case-' + (@currentX) + '-' + (@currentY + 1)) .text('')

          $('#slide').text('Non')
          $('#slide-speed').text('0')
          $('#distance').text('?')
          $('#mouse-x').text('?')
          $('#mouse-y').text('?')

        $('#area-length').text $('.map area').length

      )
  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jMap::defaults =
  borderClass: 'border'
  heightTile: 22
  widthTile: 40
  callback: -> 

$.fn.jMap = (options) ->
  @each ->
    if $(@).data('jMap') is undefined
      plugin = new $.jMap(@, options)
      $(@).data('jMap', plugin)