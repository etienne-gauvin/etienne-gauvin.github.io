define (require) ->
    
    Entity = require 'cs!game/core/Entity'
    easeout = require('cs!helper').easeout
    
    class Background extends Entity
        
        # Constructeur
        constructor: (@scene) ->
            super(@scene)
            
            @t = 0
            
            # Spritesheet de l'avion
            @layers = [
                {
                    oncoming: 'bottom'
                    speed: 10
                    alpha: 0.6
                    image: @scene.game.assets.backgroundMountainsB
                }, {
                    oncoming: 'bottom'
                    speed: 20
                    alpha: 1
                    image: @scene.game.assets.backgroundMountainsA
                }, {
                    oncoming: 'top'
                    speed: 40
                    alpha: 0.6
                    image: @scene.game.assets.backgroundClouds
                }
            ]
        
        # Mise à jour
        # @param Number dt
        handleUpdate: (dt) ->
            @t += dt
        
        # Affichage
        # @param CanvasRenderingContext2D
        handleDraw: ->
            @ctx.save()
            
            l = 0
            for layer in @layers
                @width = layer.image.width
                
                x = -@t * layer.speed  % @scene.width
                x -= @width while x + @width > 0
                
                y = 0
                
                # Première apparition animée des fonds
                oncomingDuration = ++l * 0.5
                y = easeout(@t, oncomingDuration, layer.image.height, -layer.image.height) if @t < oncomingDuration
                y = -y if layer.oncoming == 'top'
                
                # Configuration de l'opacité
                @ctx.globalAlpha = layer.alpha or 1
                
                # Affichage du nombre de fonds nécessaire
                while x < @scene.width
                    @ctx.drawImage(layer.image, x, y)
                    x += @width
            
            @ctx.restore()
        