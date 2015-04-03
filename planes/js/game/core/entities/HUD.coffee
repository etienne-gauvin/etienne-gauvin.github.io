# Classe abstraite représentant une scène
define (require) ->
    
    Layer = require 'cs!game/core/Layer'
    
    class HUD extends Layer
        
        construct: (@parent) ->
            super @parent