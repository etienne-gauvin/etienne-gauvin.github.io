# Classe abstraite représentant une scène
define (require) ->
    
    Entity = require 'cs!game/core/Entity'
    
    class Layer extends Entity
        
        construct: (@parent) ->
            super @parent
            
            @compositeOperation = no
            @alpha = 1
        
        # Gérer un nouvel affichage
        handleDraw: ->
            @ctx.save()
            @ctx.translate(@x, @y)
            @ctx.rotate(@angle)
            
            @ctx.globalCompositeOperation = @compositeOperation if @compositeOperation?
            @ctx.globalAlpha = @alpha if @alpha < 1
            
            @drawChildren()
            
            @ctx.restore()
        