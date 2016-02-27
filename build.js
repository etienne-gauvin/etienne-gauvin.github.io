const request = require('request')
const fs = require('fs')
const path = require('path')
const handlebars = require('handlebars')
const beautify = require('js-beautify').js_beautify
const striptags = require('striptags')
const minify = require('html-minifier').minify

const less = require('less')

const config = require('./config')

/**
 * Mise à jour de la base  de données locale
 */
function update() {

  var params = {
    json: true,
    url: `http://api.tumblr.com/v2/blog/${config.tumblr.baseHostname}/posts?api_key=${config.tumblr.apiKey}`
  }

  request(params, (error, response, body) => {
    if (!error && response.statusCode === 200) {
      if (body.meta.status !== 200 || body.meta.msg !== 'OK') {
        console.error(`error ${body.meta.status} : ${body.meta.msg}`)
      }
      else {
        var data = {
          blog: body.response.blog,
          posts: {}
        }
        
        // Réordonner les posts en fonction de leur date de parution
        body.response.posts.sort((postA, postB) => {
          if (postA.timestamp < postB.timestamp)
            return 1
          else if (postA.timestamp > postB.timestamp)
            return -1
          else
            return 0
        })

        data.tags = []

        for (var i = 0; i < body.response.posts.length; i++) {
          var post = body.response.posts[i]

          post.isText = (post.type == 'text')
          post.isPhoto = (post.type == 'photo')
          post.isVideo = (post.type == 'video')
          post.tagsString = post.tags.join(', ')
          post.dateString = (new Date(post.date)).toDateString()

          if (post.title) {
            post.hasTitle = true
          }

          if (post.body) {
            post.excerpt = striptags(post.body).substr(0, 200) + '…'
            
            if (post.excerpt.length > 50) {
              post.excerptFadeOut = true
            }
          }

          for (var t = 0; t < post.tags.length; t++) {
            if (data.tags.indexOf(post.tags[t]) === -1) {
              data.tags.push(post.tags[t])
            }
          }

          if (typeof post.photos !== 'undefined') {

            if (post.caption) {
              post.hasCaption = true
              
              if (post.caption.length > 50) {
                post.excerptFadeOut = true
              }
            }
            
            if (post.photos.length > 1)
              post.moreThanOnePhoto = true

            for (var p = 0; p < post.photos.length; p++) {
              var photo = post.photos[p]

              if (p === 0) {
                post.firstPhoto = photo
              }

              var prevSize = photo.original_size;

              for (var az = 0; az < photo.alt_sizes.length; az++) {
                var altSize = photo.alt_sizes[az]

                if (altSize.width >= 500) {
                  prevSize = altSize
                }
                else {
                  break
                }
              }

              photo.width_min_500 = prevSize
            }
          }
          else if (typeof post.body !== 'undefined') {
            var match = post.body.match(/src="([^"]+\.(?:gif|jpe?g|png))"/)

            if (match !== null) {
              post.coverPhoto = match[1]

              console.log(post.coverPhoto);
            }
          }

          data.posts[post.id] = post;
        }

        // Templates + data => HTML
        build(data, (data) => {
          var jsonData = beautify(JSON.stringify(data), { indent_size: 2 })

          fs.writeFile(config.paths.data, jsonData, (err) => {
            if (err) {
              console.error(`err: ${err}`)
            }
          })
        })

        // Fichier LESS => CSS
        fs.readFile(config.paths.less, (err, data) => {
          if (err) {
            console.error('err: ', err)
          }
          else {
            less.render(data.toString(), { compress: true }, (err, output) => {
              if (err) {
                console.error('err: ', err)
              }
              else {
                fs.writeFile(config.paths.css, output.css, (err) => {
                  if (err) {
                    console.error('err: ', err)
                  }
                  else {
                    console.log('done: ', config.paths.css)
                  }
                })
              }
            })
          }
        })
      }
    }
    else {
      console.error(response.statusCode, error)
    }
  })
}

function build(data, callback) {

  var readTmpl = (name) => {
    return fs.readFileSync(path.join(config.paths.templates, `${name}.hbs`).toString())
  }

  const templates = {
    header: readTmpl('header'),
    footer: readTmpl('footer'),
    index: readTmpl('index'),
    post: readTmpl('post')
  }

  try {
    var indexPath = path.join(config.paths.build, 'index.html')
    if (fs.statSync(indexPath)) {
      fs.unlinkSync(indexPath)
    }
  }
  catch (e) {
    console.warn(e.toString())
  }

  var postsPath = path.join(config.paths.build, 'posts')
  var files = fs.readdirSync(postsPath)

  for (var f = 0; f < files.length; f++) {
    var filePath = path.join(postsPath, files[f])

    if (filePath.indexOf('.html')) {
      try {
        fs.unlinkSync(filePath)
      }
      catch (e) {
        console.warn(e.toString())
      }
    }
  }

  var indexTemplate = handlebars.compile(`${templates.header}\n${templates.index}\n${templates.footer}`)
  var postTemplate = handlebars.compile(`${templates.header}\n${templates.post}\n${templates.footer}`)

  for (var p in data.posts) {
    var post = data.posts[p]

    var filePath = post.id + ""

    if (post.slug) {
      filePath += "-" + post.slug
    }

    post.filename = filePath + '.html'
    filePath = path.join(postsPath, post.filename)

    writeTemplate(filePath, postTemplate, post)
  }

  data.isIndexPage = true
  writeTemplate(indexPath, indexTemplate, data)

  callback(data)
}

function writeTemplate(path, template, data) {
  data.basePath = "/."
  data.assetsPath = "/assets"

  var html = template(data)
  
  html = minify(html, {
    removeComments: true,
    collapseWhitespace: true,
    removeTagWhitespace: true,
    minifyJS: true
  })

  var err = fs.writeFileSync(path, html)

  if (!err) {
    console.log(`done: ${path}`)
  }
  else {
    console.error(`err: ${err}`)
  }
}

update()
