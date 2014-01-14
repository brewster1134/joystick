###
joystick
https://github.com/brewster1134/joystick
@version 0.0.3
@author Ryan Brewster
###

((window, document) ->
  # Polyfill for console.log
  #
  window.console ||= { log: -> }

  # Polyfill for CustomEvent
  # https://github.com/d4tocchini/customevent-polyfill
  #
  CustomEvent = (event, params) ->
    params = params ||
      bubbles: false
      cancelable: false
      detail: `undefined`

    evt = document.createEvent 'CustomEvent'
    evt.initCustomEvent event, params.bubbles, params.cancelable, params.detail
    evt
  CustomEvent:: = window.Event::
  window.CustomEvent = CustomEvent

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
      @centerX = 0
      @centerY = 0
      @deltaX = 0
      @deltaY = 0
      @details = ->
        detail:
          deltaX: @deltaX
          deltaY: @deltaY

      @moveEvent = -> new CustomEvent 'joystick.move', @details()
      @upEvent = -> new CustomEvent 'joystick.up', @details()
      @downEvent = -> new CustomEvent 'joystick.down', @details()

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
      e.preventDefault()
      @centerX = e.clientX || e.touches[0].clientX
      @centerY = e.clientY || e.touches[0].clientY
      @isDown = true
      for listener in @listeners.down
        listener.dispatchEvent @downEvent()

    onEventMove: (e) =>
      e.preventDefault()
      if @isDown
        @deltaX = (e.clientX || e.touches[0].clientX) - @centerX
        @deltaY = (e.clientY || e.touches[0].clientY) - @centerY
        for listener in @listeners.move
          listener.dispatchEvent @moveEvent()

    onEventUp: (e) =>
      e.preventDefault()
      @isDown = false
      for listener in @listeners.up
        listener.dispatchEvent @upEvent()

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
