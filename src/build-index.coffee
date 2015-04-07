fs = require 'fs'
path = require 'path'
Handlebars = require 'handlebars'

# Emplacement des templates
template_dir = path.join __dirname, 'templates'

# Enregistrement des partials
for filename in fs.readdirSync(path.join(template_dir, 'partials'))
    partialName = filename.substr(0, filename.lastIndexOf(path.extname(filename)))
    partial = fs.readFileSync(path.join(template_dir, 'partials/', filename)).toString()
    
    Handlebars.registerPartial partialName, partial
    
# Données
data = JSON.parse fs.readFileSync path.join(__dirname, 'data.json')

# Index
indexHBS = fs.readFileSync(path.join(template_dir, 'index.hbs')).toString()

# Partials

# Template principal
indexTemplate = Handlebars.compile indexHBS

fs.writeFileSync('index.html', indexTemplate(data))
