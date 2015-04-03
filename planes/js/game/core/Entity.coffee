# Classe Entity
define (require) ->
    'use strict'

    Object = require 'cs!game/core/Object'
    
    # Entité (objet ayant une présence dans le jeu)
    class Entity extends Object
        
        # Constructeur
        constructor: (@parent) ->
            
            @game = @parent.game
            @ctx = @parent.ctx
            
            # Position
            @x = @y = 0
            
            # Dimensions
            @width = @height = 0
            
            # Centre absolu de l'objet, en fonction de sa taille (read only)
            @get 'centerX', => @x + Math.cos(@angle) * @width / 2
            @get 'centerY', => @y + Math.sin(@angle - Math.PI) * @height / 2
            @set 'centerX', =>
            @set 'centerY', =>
            
            # Angle (en radians)
            @angle = 0
            
            # Angle (en degrés, lié à l'angle en radians)
            @get 'degAngle', => @angle / Math.PI/2 * 360
            @set 'degAngle', (val) =>
                @angle = val / 360 * Math.PI * 2
            
            # Vélocité (en pixel/s)
            @vel =
                x: 0
                y: 0
            
            # Entités enfants
            @children = []
            
            # Écouteurs
            @listeners = {}
            
            # Pour masquer ou empêcher la mise de l'entité
            @visible = yes
            @updatable = yes
        
        ## Méthodes de gestion des évènements
        
        # Gérer une mise à jour
        # @param Number dt Temps en secondes depuis la dernière mise à jour
        handleUpdate: (dt) ->
            @updateChildren(dt)
        
        # Gérer un nouvel affichage
        handleDraw: ->
            @drawChildren(dt)
        
        # Destruction de l'entité
        # @param Function callback est appelée quand l'entité est bien détruite
        handleDestruction: (callback) ->
            callback()
        
        # Lors de l'appui sur une touche
        handleKeyDown: (event) ->
            @dispatchEvent(event)
        
        # Lors du relâchement d'une touche
        handleKeyUp: (event) ->
            @dispatchEvent(event)
        
        ## Routines
        ## (permettent de clarifier le code)
        
        # Mise à jour des enfants
        updateChildren: (dt) ->
            for child in @children
                child.handleUpdate(dt) if child? and child.updatable
        
        # Affichage des enfants
        drawChildren: ->
            for child in @children
                child.handleDraw() if child? and child.visible
        
        # Mise à jour de la position de l'entité en fonction de sa vitesse
        updatePosition: (dt) ->
            @x += @vel.x * dt
            @y += @vel.y * dt
        
        # Appliquer les écouteurs sur les évènements clavier
        listenToKeyboardEvents: ->
            @game.addEventListener('keydown', (event) => @handleKeyDown(event))
            @game.addEventListener('keyup', (event) => @handleKeyUp(event))
        
        # Ajout d'un enfant
        addChild: (child) ->
            @children.push(child)
        
        # Retirer une entité enfant
        removeChild: (theChild) ->
            for c, child of @children
                delete @children[c] if child is theChild
        
        ## Méthodes effectuant une vérification
        ## (retournent un booléen)
        
        # Détermine si l'entité est hors du parent
        isOffParent: ->
            @x + @width < 0 or @y + @height < 0 or
            @x > @parent.width or @y > @parent.height
        
        # Détermine si l'entité est hors de la zone visible du jeu
        isOffGameScreen: ->
            @x + @width < 0 or @y + @height < 0 or
            @x > @game.width or @y > @game.height
        
        ## Implémentation (partielle) de l'interface EventTarget
        
        # Ajouter un écouteur
        # @param String type
        # @param Function listener
        addEventListener: (type, listener) ->
            @listeners[type] = @listeners[type] or []
            @listeners[type].push(listener)
        
        # Enlever un écouteur
        # @param String type
        # @param Function listener
        removeEventListener: (type, theListener) ->
            for l, listener of @listeners[type]
                delete @listeners[type][l] if listener is theListener
        
        # Propager un évènement au écouteurs
        # @param Event event
        dispatchEvent: (event) ->
            for l, listener of @listeners[event.type]
                listener(event) if typeof listener is 'function'
            
            return true
        