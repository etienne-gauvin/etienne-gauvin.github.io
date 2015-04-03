define (require) ->
    
    Scene = require 'cs!game/core/entities/Scene'
    
    class LoadingScene extends Scene
        
        # Progression du chargement
        handleLoadProgress: (e) ->
            @progress = e.progress
        
        # Progression du chargement
        handleFileLoad: ->
        
        # Mise à jour
        handleUpdate: (dt) ->
            @t += dt
        
        # Affichage
        handleDraw: (ctx) ->
            ctx.fillStyle = '#bbedf3'
            ctx.fillRect(0, 0, @game.width, @game.height)
            
            ctx.fillStyle = '#db7d39'
            for i in [0 .. 3]
                if i < Math.floor(@game.t * 3) % 4
                    ctx.fillRect(12 + 24 * i, @game.height - 24, 12, 12)
        
        # Chargement terminé
        handleLoadComplete: ->
            console.log 'Chargement terminé'
            @game.switchToScene(@game.scenes.play)
        