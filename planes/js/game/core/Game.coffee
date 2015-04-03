define (require) ->

    Entity = require 'cs!game/core/Entity'
    Keyboard = require 'cs!game/core/Keyboard'
    
    class Game extends Entity
        # Constructeur
        constructor: (@config) ->
            
            @game = @
            @canvas = document.getElementById('canvas')
            @ctx = @canvas.getContext('2d')
            
            super @
            
            # Dimensions
            @width = @canvas.width
            @height = @canvas.height
            
            # Temps écoulé depuis le démarrage du jeu
            @t = 0
            
            # Images, sons, etc.
            @assets = {}
            
            # Représentation du clavier
            @keyboard = new Keyboard @
            
            # Scenes
            @scenes = {}
            
            # Scene actuelle
            @scene = null
            
            # Pause
            @pause = no
        
        # Démarrer le jeu
        start: ->
            # Application des écouteurs clavier
            window.addEventListener 'keydown', (e) => @handleKeyDown(e)
            window.addEventListener 'keyup', (e) => @handleKeyUp(e)
            
            # Changement de la visibilité de la fenêtre
            document.addEventListener "visibilitychange", => @handleVisibilityChange(not document.hidden)
            
            # File de chargement des assets
            loadQueue = new createjs.LoadQueue()
            loadQueue.loadManifest(@config.assetsManifest, false, @config.assetsBasePath)

            # A la fin du chargement, lancer le jeu
            loadQueue.on "complete", (e) => @handleLoadComplete(e)
            loadQueue.on "progress", (e) => @handleLoadProgress(e)
            loadQueue.on "fileload", (e) => @handleFileLoad(e)

            # Lancement du chargement
            @scenes.loading.handleStart()
            loadQueue.load()
            
            # Création du ticker
            dt = 0
            lastTime = (new Date).getTime()
            anim = =>
                now = (new Date).getTime()
                dt = now - lastTime
                lastTime = now
                @handleUpdate(dt / 1000)
                window.requestAnimationFrame anim
            
            window.requestAnimationFrame anim
            
        
        # Mise à jour du jeu puis de l'affichage
        handleUpdate: (dt) ->
            if not @pause
                @t += dt
                @scene.handleUpdate(dt) if @scene
            
            @scene.handleDraw(@ctx) if @scene
        
        # Lors de l'appui sur une touche
        handleKeyDown: (event) ->
            event.preventDefault() if event.keyCode < 100
            @keyboard.keys[event.keyCode] = true
            @scene.handleKeyDown(event) if @scene

        # Lors du relâchement d'une touche
        handleKeyUp: (event) ->
            @keyboard.keys[event.keyCode] = false
            @scene.handleKeyUp(event) if @scene
        
        # Lors changement de visibilité de la fenêtre
        handleVisibilityChange: (visible) ->
            @pause = yes if not visible
        
        # Progression du chargement
        handleLoadProgress: (e) ->
        
        # Progression du chargement
        handleFileLoad: (e) ->
            @assets[e.item.id] = e.result
        
        # Chargement terminé
        handleLoadComplete: (e) ->
        
        # Changer de scène
        switchToScene: (scene) ->
            if @scene
                @scene.handleStop =>
                    @scene = scene
                    @scene.handleStart()
            else
                @scene = scene
                @scene.handleStart()