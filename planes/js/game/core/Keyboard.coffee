# Classe représentant le clavier (destinée à n'être instanciée qu'une seule fois)
define (require) ->
    class Keyboard
        
        UP:    38
        DOWN:  40
        RIGHT: 39
        LEFT:  37

        Z: 90
        Q: 81
        S: 83
        D: 68

        SPACE: 32
        C: 67
        
        constructor: (@game) ->
        
            # Témoins de pression
            @keys = []
            
            # Écouteurs
            @game.addEventListener 'keydown', (event) =>
                event.preventDefault() if event.keyCode < 100
                @keys[event.keyCode] = true
            
            @game.addEventListener 'keyup', (event) =>
                event.preventDefault() if event.keyCode < 100
                @keys[event.keyCode] = false
            
            
        # Vérifier si une touche est enfoncée
        isDown: (keyCode) -> @keys[keyCode]
        