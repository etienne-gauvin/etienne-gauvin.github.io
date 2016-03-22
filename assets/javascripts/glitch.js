(function (window) {
  var document = window.document
  var rand = function(a, b) {
    
    if (typeof a !== 'number') {
      a = 0
    }
    
    if (typeof b !== 'number') {
      b = 1
    }
    
    return Math.random() * (b - a) + a
  }
  
  var randInt = function(a, b) {
    return Math.floor(rand(a, b))
  }
  
  
  var width = 500
  var height = 500
  var hover = false
  
  var header = document.querySelector('.page-header h1 a')
  var headerImg = document.querySelector('.page-header h1 a > img')
  
  var canvas = document.createElement('canvas')
  canvas.setAttribute('width', width)
  canvas.setAttribute('height', height)
  
  if (!canvas.getContext) {
  	return false
  }
  
  header.removeChild(headerImg)
  header.appendChild(canvas)
  
  var ctx = window.ctx = canvas.getContext('2d')
  ctx.drawImage(headerImg, 0, 0, width, height)
  
  var buffer = document.createElement('canvas')
  buffer.setAttribute('width', width)
  buffer.setAttribute('height', height)
  var bctx = window.ctx = canvas.getContext('2d')
  
  hlines = []
  
  bufferX = 0
  
  function draw(dt) {
    
    var sx = 0, sy = 0
    var sw = headerImg.width, sh = headerImg.height
    var dx = 0, dy = 0
    var dw = width, dh = height
    
  	if (hover && rand() > .96 || rand() > .99) {
      dx = rand(-5, 5)
      dw = width + rand(-10, 10)
      dh = height + rand(-10, 10)
  	}
    
    ctx.drawImage(
      headerImg,
      sx, sy, sw, sh,
      dx, dy, dw, dh
    )
    
    if (hover && rand() > .96 || rand() > .99) {
      ry = rand(0, 0.8)
      rh = rand(0, 0.5)
      
      rs = rand(0.95, 1.05)
      
      ctx.globalCompositeOperation = 'overlay'
      ctx.drawImage(
        headerImg,
        
        sx, sh * ry,
        sw, sh * rh,
        
        dx, dh * ry * rs / 2,
        dw, dh * rh * rs
      )
    }
    
    if (hover && rand() > .98 || rand() > .995) {
      ry = rand(0, 0.8)
      rh = rand(0, 0.2)
      
      rs = rand(1.5, 2)
      
      ctx.drawImage(
        headerImg,
        
        sx, sh * ry,
        sw, sh * rh,
        
        dx, dh * ry * rs / 2,
        dw, dh * rh * rs
      )
    }
    
    if (hover && rand() > .90 || rand() > .97) {
      var rx = rand(0.1, 0.9), ry = rand(0.1, 0.9)
      var rw = rand(0.3, 0.7), rh = rand(0.001, 0.02)
      
      ctx.globalCompositeOperation = 'difference'
      ctx.fillStyle = 'hsla(' + randInt(0, 360) + ', 50%, 50%, 1)'
      ctx.fillRect(rx * width, ry * height, rw * width, rh * height)
    }
  }
  
	canvas.addEventListener('mouseover', function(e) {
    hover = true
	})

	canvas.addEventListener("mouseout", function(e) {
	  hover = false
	})
  
  function main() {
    ctx.clearRect(0, 0, width, height)
  	ctx.save()
    draw()
    ctx.restore()
  	window.requestAnimationFrame(main)
  }
  
  main()
  
})(window)