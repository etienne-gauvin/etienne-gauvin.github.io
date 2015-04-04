define (require) ->
    
    Entity = require 'cs!game/core/Entity'
    floor = Math.floor
    
    class BulletFireShotSprite extends Entity
        
        # Constructeur
        constructor: (@parent) ->
            super @parent
            
            @image = @game.assets.bulletFireShot
            @lumImage = @game.assets.lum
            
            @width = 16 * 3
            @height = 7 * 3
            
            @t = 10
            @duration = 0.1
            @imgN = 0
            
        
        # Mise à jour
        # @param Number dt
        handleUpdate: (dt) ->
            @t += dt
        
        # Affichage
        # @param CanvasRenderingContext2D
        handleDraw: ->
            if @t < @duration
                @ctx.save()
                @ctx.globalAlpha = 1 - @t / @duration
                
                @ctx.drawImage(
                    @image,
                    0, @imgN * @height,
                    @width,
                    @height,
                    @parent.width,
                    @parent.height / 2 - @height / 2 + 4,
                    @width,
                    @height)
                
                @ctx.drawImage(
                    @lumImage,
                    @parent.width - @lumImage.width / 2,
                    @parent.height / 2 + 4 - @lumImage.height / 2)
                
                @ctx.restore()
        
        # (Re-)lancer l'animation
        run: ->
            @t = 0
            @imgN = Math.floor(Math.random() * @image.height / @height)
            