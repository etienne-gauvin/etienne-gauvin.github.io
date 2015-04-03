define (require) ->
    
    Layer = require 'cs!game/core/entities/Layer'
    
    class HUD extends Layer
        
        # Constructeur
        constructor: (@game) ->
            super @game
            
            @markForUpdate = yes
        
        # Mise à jour de la scène
        # @param Number dt
        handleUpdate: (dt) ->
            @update(dt) if @markForUpdate
            super
        
        # Mise à jour de la scène
        # @param Number dt
        update: (dt) ->
            for entity in @entities
                entity.handleUpdate(dt) if entity?
        
        # Affichage de la scène
        # @param CanvasRenderingContext2D
        handleDraw: (ctx) ->
            @drawEntities(ctx)
        
        # Arrêt de la scène
        # @param Function callback est appelée quand la scène est bien arrêtée
        handleStop: (callback) ->
            callback()
        