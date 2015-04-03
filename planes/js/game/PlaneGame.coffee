define (require) ->
    
    Game = require 'cs!game/core/Game'
    LoadingScene = require 'cs!game/scenes/LoadingScene'
    PlayScene = require 'cs!game/scenes/PlayScene'
    
    window.log = (params...) -> console.log params...

    class PlaneGame extends Game
        # Constructeur
        constructor: (@config) ->
            super @config
            
            # Scenes
            @scenes =
                loading: new LoadingScene @
                play: new PlayScene @
        
        # Démarrer le jeu
        start: ->
            super
            @switchToScene @scenes.loading
        
        # Progression du chargement
        handleLoadProgress: (e) ->
            @scenes.loading.handleLoadProgress e
        
        # Chargement terminé
        handleLoadComplete: (e) ->
            @scenes.loading.handleLoadComplete e
        