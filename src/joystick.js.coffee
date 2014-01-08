###
joystick
https://github.com/brewster1134/joystick
@version 0.0.1
@author Ryan Brewster
###

((window, document) ->
  window.console ||= { log: -> }
  window.Joystick = class Joystick
    constructor: (options) ->
      @el = document.getElementById options.id

      if @el
        @boundingEl = document.getElementById(options.boundingId) || document.body
        @init()

    init: ->
      @listeners =
        down: []
        move: []
        up: []
      @isDown = false
      @centerX = null
      @centerY = null
      @deltaX = null
      @deltaY = null
      @moveEvent = ->
        new CustomEvent 'joystick.move',
          detail:
            deltaX: @deltaX
            deltaY: @deltaY
      @upEvent = new CustomEvent 'joystick.up'
      @downEvent = new CustomEvent 'joystick.down'

      @bindEvents()

    bindEvents: ->
      # Only bind `down` events to the element
      @el.addEventListener 'touchstart', @onEventDown
      @el.addEventListener 'mousedown', @onEventDown

      # Bind `move` and `up` events to the body so they always fire
      @boundingEl.addEventListener 'mouseup', @onEventUp
      @boundingEl.addEventListener 'mousemove', @onEventMove
      @boundingEl.addEventListener 'touchend', @onEventUp
      @boundingEl.addEventListener 'touchmove', @onEventMove

    # Event Methods
    # use double rockets for event listenere methods to enforce correct context
    #
    onEventDown: (e) =>
      @centerX = e.clientX
      @centerY = e.clientY
      @isDown = true
      for listener in @listeners.down
        listener.dispatchEvent @downEvent

    onEventUp: =>
      @isDown = false
      for listener in @listeners.up
        listener.dispatchEvent @upEvent

    onEventMove: (e) =>
      if @isDown
        @deltaX = e.clientX - @centerX
        @deltaY = e.clientY - @centerY
        for listener in @listeners.move
          listener.dispatchEvent @moveEvent()

    # PUBLIC METHODS
    #
    onDown: (el, callback) ->
      el.addEventListener 'joystick.down', callback
      @listeners.down.push el

    onMove: (el, callback) ->
      el.addEventListener 'joystick.move', callback
      @listeners.move.push el

    onUp: (el, callback) ->
      el.addEventListener 'joystick.up', callback
      @listeners.up.push el

)(window, document)
