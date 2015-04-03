requirejs.config({
    baseUrl: 'js/lib',
    paths: {
        game: '../game'
    }
});

/**
 * Démarrage
 */
requirejs(
    [
        'cs!game/config',
        'cs!game/PlaneGame',
        'easeljs',
        'preloadjs'
    ],
    
    // Lancement du jeu
    function (config, Game) {
        var game = new Game(config)
        game.start()
        
        
        
        // Objet global, plus pratique pour le développement
        window.game = game
    }
);