# joystick

## Usage

```coffee
# create a new joystick
joystick = new Joystick
  id: 'joystick'          # id of the element to be used as the joystick.  Click and touch events will only happen on this element.
  boundingId: 'container' # id of the element where events will be bound.  Movement outside this element will not fire events. Default is the body tag.

# bind to any element you want to send joystick events to.
joystick.onMove document.getElementById('foo'), (e) ->
  # event fires each time the joystick position changes.
  # moves #foo element based on distance joystick is moved
  @style.left = e.detail.deltaX
  @style.top = e.detail.deltaY

joystick.onUp document.getElementById('foo'), ->
  # resets the joystick position
  @style.left = 0
  @style.top = 0
```

## Development

### Dependencies
* Ruby
* Bundler Gem
* Node.js
* npm
* Testem
* PhantomJS

_Optional_

* Growl _\* for <= OS X Lion 10.7_

### Compiling
`bundle exec guard`

Do **NOT** modify any `.js` files!  Modify the coffee files in the `src` directory.  Guard will watch for changes and compile them to the `lib` directory.

### Testing
Run `testem`

_- or -_

Run `testem -g` if running OS X Lion or below for Growl support

## To-Do
* tests

## Contributing
1. Fork it ( http://github.com/brewster1134/joystick/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
