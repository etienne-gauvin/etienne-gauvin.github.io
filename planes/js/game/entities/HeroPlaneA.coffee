define (require) ->
    
    HeroPlane = require 'cs!game/entities/HeroPlane'
    
    class HeroPlaneA extends HeroPlane
        
        # Constructeur
        constructor: (@parent) ->
            super @parent
            
            @image = @game.assets.heroPlaneA
            
            # Tirs
            @gun.cadency = 0.15
            @gun.precision = 0.5