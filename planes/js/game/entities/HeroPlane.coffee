define (require) ->
    'use strict'
    
    Plane = require 'cs!game/entities/Plane'
    
    class HeroPlane extends Plane
        
        # Constructeur
        # @param Scene @scene
        # @param String @version a|b|c
        constructor: (@scene) ->
            super @scene
            
            @x = @y = 0
            
            @image = @scene.game.assets.heroPlaneA
            
            # Munitions
            @gun.ammoMax = 40
            @gun.ammo = 40
            
        
        # Mise à jour
        # @param Number dt
        handleUpdate: (dt) ->
            
            kb = @game.keyboard
            
            @goUp = kb.isDown(kb.UP) or kb.isDown(kb.Z)
            @goDown = kb.isDown(kb.DOWN) or kb.isDown(kb.S)
            @goForward = kb.isDown(kb.RIGHT) or kb.isDown(kb.D)
            @goBackward = kb.isDown(kb.LEFT) or kb.isDown(kb.Q)
            
            @gun.shoot = kb.isDown(kb.SPACE)
            
            @updateVelocity(dt)
            @updateVelocityToKeepOnScreen(dt)
            
            @updatePosition(dt)
            @updateGun(dt)
            
            if @isOffGameScreen()
                @x = 10
                @y = @scene.height / 2 - @height / 2