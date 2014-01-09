describe 'joystick', ->
  joystick = null
  $joystickEl = null
  $boundingEl = null
  joystickElListenerSpy = null
  boundingElListenerSpy = null

  before ->
    $boundingEl = $('body')
    $joystickEl = $('<div id="joystick"/>').appendTo($boundingEl)

    joystickElListenerSpy = sinon.spy $joystickEl[0], 'addEventListener'
    boundingElListenerSpy = sinon.spy $boundingEl[0], 'addEventListener'

    joystick = new Joystick
      id: $joystickEl.attr('id')
      boundingId: $boundingEl.attr('id')

  after ->
    joystickElListenerSpy.restore()
    boundingElListenerSpy.restore()

  it 'should initialize all neccessary attributes', ->
    expect(joystick.el).to.equal($joystickEl[0])
    expect(joystick.boundingEl).to.equal(document.body)
    expect(joystick.listeners.down).to.be.empty
    expect(joystick.listeners.move).to.be.empty
    expect(joystick.listeners.up).to.be.empty
    expect(joystick.isDown).to.be.false
    expect(joystick.centerX).to.equal 0
    expect(joystick.centerY).to.equal 0
    expect(joystick.deltaX).to.equal 0
    expect(joystick.deltaY).to.equal 0
    expect(joystick.details).to.be.an('function')
    expect(joystick.moveEvent).to.be.an('function')
    expect(joystick.upEvent).to.be.an('function')
    expect(joystick.downEvent).to.be.an('function')

  it 'should bind events', ->
    expect(joystickElListenerSpy).to.be.calledWith('touchstart')
    expect(joystickElListenerSpy).to.be.calledWith('mousedown')

    expect(boundingElListenerSpy).to.be.calledWith('mouseup')
    expect(boundingElListenerSpy).to.be.calledWith('mousemove')
    expect(boundingElListenerSpy).to.be.calledWith('touchend')
    expect(boundingElListenerSpy).to.be.calledWith('touchmove')

  # Public methods
  #
  context '.onDown', ->
    el = null
    onDownDetails = null

    before ->
      el = $('<div id="on-down"></div>')[0]
      joystick.listeners.down = []
      joystick.onDown el, (e)->
        onDownDetails = e.detail

    beforeEach ->
      # https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
      # annyoing have to pass all mouse event attributes so we can mock clientX & clientY
      evObj = document.createEvent 'MouseEvents'
      evObj.initMouseEvent 'mousedown', true, true, window, null, 0, 0, 1, 2, false, false, false, false, 0, null
      $joystickEl[0].dispatchEvent evObj

    it 'should add element to listeners array', ->
      expect(joystick.listeners.down).to.include el

    it 'should pass details in event', ->
      expect(onDownDetails.deltaX).to.equal 0
      expect(onDownDetails.deltaY).to.equal 0

    context '.onEventDown', ->
      before ->
        joystick.isDown = false

      it 'should set the center coordinates', ->
        expect(joystick.centerX).to.equal 1
        expect(joystick.centerY).to.equal 2

      it 'should set the isDown attribute', ->
        expect(joystick.isDown).to.be.true

  context '.onMove', ->
    el = null
    onMoveDetails = null

    before ->
      el = $('<div id="on-move"></div>')[0]
      joystick.listeners.move = []
      joystick.isDown = true
      joystick.centerX = 4
      joystick.centerY = 5
      joystick.onMove el, (e) ->
        onMoveDetails = e.detail

    beforeEach ->
      # https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
      # annyoing have to pass all mouse event attributes so we can mock clientX & clientY
      evObj = document.createEvent 'MouseEvents'
      evObj.initMouseEvent 'mousemove', true, true, window, null, 0, 0, 1, 2, false, false, false, false, 0, null
      $joystickEl[0].dispatchEvent evObj

    it 'should add element to listeners array', ->
      expect(joystick.listeners.move).to.include el

    it 'should pass details in event', ->
      expect(onMoveDetails.deltaX).to.equal -3
      expect(onMoveDetails.deltaY).to.equal -3

    context '.onEventMove', ->
      before ->
        joystick.isMove = false

      it 'should set the delta coordinates', ->
        expect(joystick.deltaX).to.equal -3
        expect(joystick.deltaY).to.equal -3

  context '.onUp', ->
    el = null
    onUpDetails = null

    before ->
      el = $('<div id="on-up"></div>')[0]
      joystick.listeners.up = []
      joystick.onUp el, (e)->
        onUpDetails = e.detail

    beforeEach ->
      # https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
      # annyoing have to pass all mouse event attributes so we can mock clientX & clientY
      evObj = document.createEvent 'MouseEvents'
      evObj.initEvent 'mouseup', true, true
      $joystickEl[0].dispatchEvent evObj

    it 'should add element to listeners array', ->
      expect(joystick.listeners.up).to.include el

    it 'should pass details in event', ->
      expect(onUpDetails).to.be.an('object')

    context '.onEventUp', ->
      before ->
        joystick.isUp = true

      it 'should unset the isDown attribute', ->
        expect(joystick.isDown).to.be.false
