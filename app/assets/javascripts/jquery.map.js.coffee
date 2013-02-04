#
# Name    : jMap
# Author  : Damien Vossen, http://www.terresdecy.be
# Version : 0.1
#

$ = jQuery

$.jMap = ( element, options ) ->
  # cur state
  state = ''

  # plugin settings
  @settings = {}

  # jQuery version of DOM element attached to the plugin
  @$element = $ element

  # set cur state
  @setState = ( _state ) -> state = _state

  #get cur state
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

      map = @ 
      map.border = map.settings['border']
      map.keySlide = false

      map.refX = 1
      map.refY = 1

      map.size         = 9
      map.borderSize   = if map.border then map.size + 1 else map.size
      map.extendedSize = (map.borderSize * 2) - 1

      xOffset         = (map.extendedSize * 2 - 2) * 0.75 * map.settings['widthTile'] / 2
      pixelWidthMap   = xOffset * 2 + map.settings['widthTile']
      pixelHeightMap  = map.settings['heightTile'] * (map.extendedSize + 2)
      widthContainer  = map.$element.width()
      heightContainer = map.$element.height()

      # Build Map
      @$element
      .html('<div class="inner" /><div class="action" />')
      .find('.action')
      .html('<img src="' + image_path('design/pixel.png') + '" usemap="#map" /><map name="map" />')

      # Focus Map
      @$element
      .append('<input class="focus-map" />')
      .find('.focus-map')
      .focus ->
        $('.case.border').addClass('focus')
        map.focus = true
      .blur ->
        $('.case.border').removeClass('focus')
        map.focus = false

      for x in [1..map.extendedSize]
        for y in [1..map.extendedSize]
          if Math.abs(y - x) < map.borderSize
            xDisplay = if map.border then x - 1 else x
            yDisplay = if map.border then y - 1 else y

            left = (x - y) *  map.settings['widthTile'] * 0.75 + xOffset
            top  = (x + y) *  map.settings['heightTile'] / 2

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
                (left + map.settings['widthTile'] * 0.25) + ', ' + 
                (top) + ', ' +
                (left + map.settings['widthTile'] * 0.75) + ', ' +
                (top) + ', ' +
                (left + map.settings['widthTile']) + ', ' +
                (top + map.settings['heightTile'] / 2) + ', ' +
                (left + map.settings['widthTile'] * 0.75) + ', ' +
                (top + map.settings['heightTile']) + ', ' +
                (left + map.settings['widthTile'] * 0.25) + ', ' +
                (top + map.settings['heightTile']) + ', ' +
                (left) + ', ' +
                (top + map.settings['heightTile'] / 2)
            })

            if map.border
              if x == 1 || y == 1 || x == map.extendedSize || y == map.extendedSize || Math.abs(x - y) == map.borderSize - 1
                $('#case-' + xDisplay + '-' + yDisplay).addClass(map.settings['borderClass']).removeAttr('id')
                $('#area-' + xDisplay + '-' + yDisplay).remove()
            
      $.get '/map.json', (data) -> 
        map.cases = data
        map.begin = parseFloat(_.first(_.keys(map.cases)))
        map.end   = parseFloat(_.last(_.keys(map.cases[map.begin])))

        for x in [1..map.extendedSize - 2]
          for y in [1..map.extendedSize - 2]
            if Math.abs(y - x) < map.borderSize
              map.buildCase(x, y)
        
        map
        .$element
        .find('area')
        .bind 'click focus', (e) ->
          e.preventDefault()
          $('.focus-map').focus()
        
        map
        .$element
        .find('area[href]')
        .mouseover ->
          caseCoord = $(@).attr('id').split('-')
          map.curX = parseFloat(caseCoord[1])
          map.curY = parseFloat(caseCoord[2])
          map.caseAround(map.curX, map.curY).text('X')
          map.slideSize = if map.border then map.borderSize - 4 else map.borderSize
          direction = 'Non'

          distance = map.distance(map.curX + '-' + map.curY, map.size + '-' + map.size)

          corner =
            '1-1'  : 'N'
            '1-9'  : 'NW'
            '9-17' : 'SW'
            '17-17': 'S'
            '17-9' : 'SE'
            '9-1'  : 'NE'

          for point, cardinal of corner
            slideDistance = map.distance(point, map.curX + '-' + map.curY)
            if slideDistance < 4
              direction  = cardinal
              map.slideSpeed = 4 - slideDistance
              break

          $('#slide').text(direction)
          $('#slide-speed').text(map.slideSpeed)
          $('#distance').text(distance)
          $('#mouse-x').text(map.curX)
          $('#mouse-y').text(map.curY)

          if map.slideSpeed && !map.initSlideTimer? && !map.slideTimer?
            map.initSlideTimer = setTimeout ->
              delete map.initSlideTimer

              if map.slideSpeed
                map.slide(direction)
              
            , 250

        .mouseout ->

          map.slideSpeed = 0
          map.caseAround(map.curX, map.curY).text('')

          $('#slide').text('Non')
          $('#slide-speed').text('0')
          $('#distance').text('?')
          $('#mouse-x').text('?')
          $('#mouse-y').text('?')

        $('#area-length').text $('.map area').length

        map.navKey()

    @move = (direction) ->
      oldRefX = map.refX
      oldRefY = map.refY
      switch direction
        when 'N'
          map.refX--
          map.refY--
        when 'S'
          map.refX++
          map.refY++
        when 'NW'
          map.refX--
        when 'SE'
          map.refX++
        when 'NE'
          map.refY--
        when 'SW'
          map.refY++

      map.refX = map.begin if map.refX < map.begin
      map.refY = map.begin if map.refY < map.begin
      map.refX = map.end - (map.size - 1) * 2 if map.refX > map.end - (map.size - 1) * 2
      map.refY = map.end - (map.size - 1) * 2 if map.refY > map.end - (map.size - 1) * 2

      $('#ref-x').text(map.refX)
      $('#ref-y').text(map.refY)

      if oldRefX != map.refX || oldRefY != map.refY
        baseMove = []
        NW = for x in [map.begin..map.size]
          map.begin + '-' + x

        NE = for x in [map.begin..map.size]
          x + '-' + map.begin

        SW = for x in [map.size..map.extendedSize - 2]
          x + '-' + (map.extendedSize - 2)

        SE = for x in [map.size..map.extendedSize - 2]
          (map.extendedSize - 2) + '-' + x

        W = for x in [0..map.size - 1]
          (map.begin + x) + '-' + (map.size + x)

        E = for x in [0..map.size - 1]
          (map.size + x) + '-' + (map.begin + x)

        switch direction
          when 'N'
            xMove = 1
            yMove = 1

            baseMove = _.union(NW, NE)

          when 'S'
            xMove = -1
            yMove = -1

            baseMove = _.union(SW, SE)

          when 'NW'
            xMove = 1
            yMove = 0

            baseMove = _.union(NW, W)

          when 'SE'
            xMove = -1
            yMove = 0
            
            baseMove = _.union(SE, E)

          when 'SW'
            xMove = 0
            yMove = -1
            
            baseMove = _.union(SW, W)
          
          when 'NE'
            xMove = 0
            yMove = 1
            
            baseMove = _.union(NE, E)

        for point in baseMove
          pointCoor = point.split('-')
          x = parseFloat(pointCoor[0])
          y = parseFloat(pointCoor[1])
          
          if map.end < (x + xMove) || map.begin > (x + xMove)
            xMove = 0
          if map.end < (y + yMove) || map.begin > (y + yMove)
            yMove = 0

          if xMove != 0 || yMove != 0
            @updateCase(x, y, xMove, yMove)
    
    @slide = (direction) ->
      map.slideTimer = setTimeout ->
        if map.slideSpeed && map.keySlide == false
          map.move(direction)
          map.slide(direction)
        else
          delete map.slideTimer

      , 125 / map.slideSpeed

    @navKey = ->
      map.key = []
      $(document)
      .keyup (e) ->
          map.key[e.which] = false if map.isCardKey(e.which)
          map.keySlide = false if _.uniq(map.key).length == 1
      .keydown (e) ->
        if map.focus
          map.key[e.which] = true if map.isCardKey(e.which)

          direction = ''
          if map.key[38] #Up
            direction = 'N'
          else if map.key[40] #Down
            direction = 'S'

          if map.key[37] #Left
            direction += 'W'
          else if map.key[39] #Right
            direction += 'E'

          if map.isCardKey(e.which)
            map.move(direction)
            map.keySlide = true

    @isCardKey = (keyCode) ->
      [37, 38, 39, 40].indexOf(keyCode) > -1

    @updateCase = (x, y, xMove, yMove) ->
      if @case(x + xMove, y + yMove).length
        @updateCase(x + xMove, y + yMove, xMove, yMove)

      @buildCase(x, y)

    @case = (x, y) ->
      $('#case-' + x + '-' + y)

    @caseAround = (x, y) ->
      $('#case-' + (x - 1) + '-' + (y - 1) +
        ', #case-' + (x + 1) + '-' + (y + 1) +
        ', #case-' + (x - 1) + '-' + (y) +
        ', #case-' + (x + 1) + '-' + (y) +
        ', #case-' + (x) + '-' + (y - 1) +
        ', #case-' + (x) + '-' + (y + 1))

    @distance = (x, y) ->
      firstCoor  = x.split '-'
      secondCoor = y.split '-'

      distanceX  = Math.abs(firstCoor[0] - secondCoor[0])
      distanceY  = Math.abs(firstCoor[1] - secondCoor[1])
      distanceXY = Math.abs((firstCoor[0] - secondCoor[0]) - (firstCoor[1] - secondCoor[1]))
      distance   = Math.max(distanceX, distanceY, distanceXY)

    @buildCase = (x, y) ->
      @case(x, y).attr('class', 'case ' + map.cases[x + map.refX - 1][y + map.refY - 1]['t'])

  # initialise the plugin
  @init()

  # make the plugin chainable
  this

# default plugin settings
$.jMap::defaults =
  borderClass: 'border',
  border: true
  heightTile: 22
  widthTile: 40
  offsetTile: 6
  callback: -> 

$.fn.jMap = (options) ->
  @each ->
    if $(@).data('jMap') is undefined
      plugin = new $.jMap(@, options)
      $(@).data('jMap', plugin)