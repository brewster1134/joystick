/*
joystick
https://github.com/brewster1134/joystick
@version 0.0.3
@author Ryan Brewster
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function(window, document) {
    var CustomEvent, Joystick;
    window.console || (window.console = {
      log: function() {}
    });
    CustomEvent = function(event, params) {
      var evt;
      params = params || {
        bubbles: false,
        cancelable: false,
        detail: undefined
      };
      evt = document.createEvent('CustomEvent');
      evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
      return evt;
    };
    CustomEvent.prototype = window.Event.prototype;
    window.CustomEvent = CustomEvent;
    return window.Joystick = Joystick = (function() {
      function Joystick(options) {
        this.onEventUp = __bind(this.onEventUp, this);
        this.onEventMove = __bind(this.onEventMove, this);
        this.onEventDown = __bind(this.onEventDown, this);
        this.el = document.getElementById(options.id);
        if (this.el) {
          this.boundingEl = document.getElementById(options.boundingId) || document.body;
          this.init();
        }
      }

      Joystick.prototype.init = function() {
        this.listeners = {
          down: [],
          move: [],
          up: []
        };
        this.isDown = false;
        this.centerX = 0;
        this.centerY = 0;
        this.deltaX = 0;
        this.deltaY = 0;
        this.details = function() {
          return {
            detail: {
              deltaX: this.deltaX,
              deltaY: this.deltaY
            }
          };
        };
        this.moveEvent = function() {
          return new CustomEvent('joystick.move', this.details());
        };
        this.upEvent = function() {
          return new CustomEvent('joystick.up', this.details());
        };
        this.downEvent = function() {
          return new CustomEvent('joystick.down', this.details());
        };
        return this.bindEvents();
      };

      Joystick.prototype.bindEvents = function() {
        this.el.addEventListener('touchstart', this.onEventDown);
        this.el.addEventListener('mousedown', this.onEventDown);
        this.boundingEl.addEventListener('mouseup', this.onEventUp);
        this.boundingEl.addEventListener('mousemove', this.onEventMove);
        this.boundingEl.addEventListener('touchend', this.onEventUp);
        return this.boundingEl.addEventListener('touchmove', this.onEventMove);
      };

      Joystick.prototype.onEventDown = function(e) {
        var listener, _i, _len, _ref, _results;
        e.preventDefault();
        this.centerX = e.clientX || e.touches[0].clientX;
        this.centerY = e.clientY || e.touches[0].clientY;
        this.isDown = true;
        _ref = this.listeners.down;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          listener = _ref[_i];
          _results.push(listener.dispatchEvent(this.downEvent()));
        }
        return _results;
      };

      Joystick.prototype.onEventMove = function(e) {
        var listener, _i, _len, _ref, _results;
        e.preventDefault();
        if (this.isDown) {
          this.deltaX = (e.clientX || e.touches[0].clientX) - this.centerX;
          this.deltaY = (e.clientY || e.touches[0].clientY) - this.centerY;
          _ref = this.listeners.move;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            listener = _ref[_i];
            _results.push(listener.dispatchEvent(this.moveEvent()));
          }
          return _results;
        }
      };

      Joystick.prototype.onEventUp = function(e) {
        var listener, _i, _len, _ref, _results;
        e.preventDefault();
        this.isDown = false;
        this.deltaX = 0;
        this.deltaY = 0;
        _ref = this.listeners.up;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          listener = _ref[_i];
          _results.push(listener.dispatchEvent(this.upEvent()));
        }
        return _results;
      };

      Joystick.prototype.onDown = function(el, callback) {
        el.addEventListener('joystick.down', callback);
        return this.listeners.down.push(el);
      };

      Joystick.prototype.onMove = function(el, callback) {
        el.addEventListener('joystick.move', callback);
        return this.listeners.move.push(el);
      };

      Joystick.prototype.onUp = function(el, callback) {
        el.addEventListener('joystick.up', callback);
        return this.listeners.up.push(el);
      };

      return Joystick;

    })();
  })(window, document);

}).call(this);
