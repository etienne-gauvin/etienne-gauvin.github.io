define (require) ->
    
    HeroPlane = require 'cs!game/entities/HeroPlane'
    
    class HeroPlaneC extends HeroPlane
        
        # Constructeur
        constructor: (@parent) ->
            super @parent
            
            @image = @game.assets.heroPlaneC
            
            # Tirs
            @gun.cadency = 0.20
            @gun.precision = 0.2
