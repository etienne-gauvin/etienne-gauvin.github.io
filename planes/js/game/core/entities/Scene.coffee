# Classe abstraite représentant une scène
define (require) ->
    
    Layer = require 'cs!game/core/entities/Layer'
    
    class Scene extends Layer
        
        name: 'Scene'
        
        # Démarrage de la scène
        handleStart: ->
        
        # Arrêt de la scène
        # @param Function callback est appelée quand la scène est bien arrêtée
        handleStop: (callback) ->
            callback()
        