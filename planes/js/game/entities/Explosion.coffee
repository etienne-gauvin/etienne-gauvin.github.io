define (require) ->
    'use strict'
    
    easeout = require('cs!helper').easeout
    
    Entity = require 'cs!game/core/Entity'
    
    class Explosion extends Entity
        
        # Constructeur
        # @param Scene @scene
        # @param String @version a|b|c
        constructor: (@parent, x = 0, y = 0) ->
            super @parent
            
            @image = @game.assets.explosion
            
            @x = x
            @y = y
            @width = @height = 36 * 3
            
            @t = 0
            @duration = 0.5
        
        # Mise à jour
        # @param Number dt
        handleUpdate: (dt) ->
            @t += dt
            @parent.removeChild(@) if @t > @duration
        
        # Affichage
        handleDraw: ->
            if @t < @duration
                @n = easeout(@t, @duration, 0, 1)
                
                @ctx.save()
                @ctx.globalAlpha = 1 - @n
                @ctx.translate(- @n * @width*.5 + @x, - @n * @height*.5 + @y)
                @ctx.scale(@n, @n)
                @ctx.drawImage(
                    @image,
                    0, Math.floor(@n * @image.height / @height) * @height,
                    @width,
                    @height,
                    0,
                    0,
                    @width,
                    @height)
                @ctx.restore()
