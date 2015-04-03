define (require) ->
    'use strict'
    
    Entity = require 'cs!game/core/Entity'
    Bullet = require 'cs!game/entities/Bullet'
    BulletFireShotSprite = require 'cs!game/entities/BulletFireShotSprite'
    floor = Math.floor
    
    class Plane extends Entity
        
        # Constructeur
        constructor: (@parent) ->
            super @parent
            
            # Spritesheet de l'avion
            @image = null
            
            # Dimensions
            @width =  24 * 3
            @height = 16 * 3
            
            # Booléens pour déplacer l'avion verticalement
            @goUp = @goDown = @goForward = @goBackward = no
            
            @vel =
                x: @vel.x
                y: @vel.y
                
                # Limites de vitesse (en pixels/s)
                ymax: 300
                ymin: -250
                xmax: 200
                xmin: -300
                
                # Gain de vitesse lors du déplacement (en pixels/s^-1)
                gain:
                    uphill:     900
                    downhill:   1000
                    forward:    500
                    backward:   1000
            
                # Perte de vitesse lorsque pas de déplacement (en pixels/s^-1)
                loss:
                    uphill:     600
                    downhill:   500
                    forward:    600
                    backward:   600
            
            # Retourne l'angle actuel selon la vitesse verticale (read only)
            @set 'angle', ->
            @get 'angle', => @getYSpeedPercentage() * 2.5
            
            # Mitrailleuse
            @gun =
                cadency: 0.15
                lastShoot: 0
                precision: 0.5
                shoot: no
                ammo: 100
                fireShotSprite: new BulletFireShotSprite @
            
        
        # Mise à jour
        # @param Number dt
        handleUpdate: (dt) ->
            @updateVelocity(dt)
            @updatePosition(dt)
            @updateGun(dt)
        
        # Représentation de la vitesse verticale de l'avion
        # comprise entre -1 (min) et 1 (max)
        getYSpeedPercentage: ->
            ySpeedPercentage = - @vel.y / @vel.ymin if @vel.y < 0
            ySpeedPercentage =   @vel.y / @vel.ymax if @vel.y > 0
            return ySpeedPercentage or 0

        # Affichage
        # @param CanvasRenderingContext2D
        handleDraw: ->
            
            frame = floor(@getYSpeedPercentage() * 3 + 0.5)
            
            @ctx.save()
            @ctx.translate(floor(@x + @width * 0.5), floor(@y + @height * 0.5))
            @ctx.rotate(frame/3*15 * Math.PI / 180)
            @ctx.translate(floor(- @width * 0.5), floor(- @height * 0.5))
            
            @ctx.drawImage(@image,
                          0, @height * (frame + 3),
                          @width, @height,
                          0, 0,
                          @width, @height)
            
            @gun.fireShotSprite.handleDraw()
            
            @ctx.restore()
        
        
        # Appliquer le déplacement vertical
        updateVelocity: (dt) ->
            
            # Gagner de la vitesse si un déplacement horizantal est demandé
            @vel.y += @vel.gain.downhill * dt if @goDown
            @vel.y -= @vel.gain.uphill   * dt if @goUp
            @vel.x += @vel.gain.forward  * dt if @goForward
            @vel.x -= @vel.gain.backward * dt if @goBackward
            
            # Appliquer une perte de vitesse si aucun sens de déplacement n'est demandé
            if not @goDown and not @goUp
                @vel.y += (@vel.y / @vel.ymin) * @vel.loss.uphill   * dt if @vel.y < 0
                @vel.y -= (@vel.y / @vel.ymax) * @vel.loss.downhill * dt if @vel.y > 0
            
            if not @goForward and not @goBackward
                @vel.x += (@vel.x / @vel.xmin) * @vel.loss.forward   * dt if @vel.x < 0
                @vel.x -= (@vel.x / @vel.xmax) * @vel.loss.backward  * dt if @vel.x > 0
            
            # Limiter la vitesse
            @vel.y = @vel.ymax if @vel.y > @vel.ymax
            @vel.y = @vel.ymin if @vel.y < @vel.ymin
            @vel.x = @vel.xmax if @vel.x > @vel.xmax
            @vel.x = @vel.xmin if @vel.x < @vel.xmin
        
        # Tirer si nécessaire
        updateGun: (dt) ->
            @gun.lastShoot += dt
            @gun.fireShotSprite.handleUpdate(dt)
            if @gun.shoot and @gun.lastShoot >= @gun.cadency and @gun.ammo > 0
                @gun.lastShoot = 0
                @gun.ammo--
                
                shotAngle = @angle + (Math.random()-.5) * @gun.precision
                
                @gun.fireShotSprite.run()
                @parent.addChild new Bullet(@, shotAngle)
                
        # Garder l'avion dans les limites de l'écran
        updateVelocityToKeepOnScreen: ->
            
            # Limiter la vitesse sur les bords de l'écran
            padding = 100
            
            # Limitation en haut
            if @vel.y < 0 and @y < padding
                @vel.y *= Math.pow((@y / padding), 0.1) or 0
            
            # Limitation en bas
            if @vel.y > 0 and @parent.height - @y - @height < padding
                @vel.y *= Math.pow(((@parent.height - @y - @height) / padding), 0.1) or 0
                
            # Limitation à droite
            if @vel.x < 0 and @x < padding
                @vel.x *= Math.pow((@x / padding), 0.1) or 0
                
            # Limitation à gauche
            if @vel.x > 0 and @parent.width - @x - @width < padding
                @vel.x *= Math.pow(((@parent.width - @x - @width) / padding), 0.1) or 0
                