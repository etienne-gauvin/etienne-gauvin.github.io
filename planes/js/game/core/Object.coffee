# Classe Object
define (require) ->
    'use strict'
    
    class Object
        
        # Shortcut for getters
        get: (key, f) ->
            @__defineGetter__ key, f
        
        # Shortcut for setters
        set: (key, f) ->
            @__defineSetter__ key, f
        
        # Use mixins in the class
        @useMixins = (mixins...) ->
            @::mixinsUsed = @::mixinsUsed or []
            for mixin in mixins
                @::mixinsUsed.push(mixin)
                @::[key] = value for key, value of mixin::
        
        # Check is a mixin is used
        isUsingMixin: (theMixin) ->
            for mixin in @mixinsUsed
                return true if mixin is theMixin
            
            # else
            return false

