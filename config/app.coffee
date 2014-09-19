###

app.coffee
Express/Httpの設定ファイル

###

# Api Dependencies
path        = require "path"
events      = require 'events'

# Module Dependencies
require.all  = require 'direquire'
express      = require "express"
mongoose     = require "mongoose"
errorhandler = require 'errorhandler'
bodyParser   = require 'body-parser'
morgan       = require 'morgan'
rollbar      = require 'rollbar'

# Static Files
connect =
  static: (require 'st')
    url: '/'
    path: path.resolve 'public'
    index: no
    passthrough: yes

app = express()

# env
app.set 'env', process.env.NODE_ENV || 'development'
app.set 'port', process.env.PORT || 3000

# views
app.set "views", path.resolve "views"
app.set "view engine", "jade"
app.disable 'x-powered-by'

# require event/models
app.set 'models',  require.all path.resolve 'models'
app.set 'events',  require.all path.resolve 'events'

# Emitter
app.set 'emitter', new events.EventEmitter()

# middlewares
app.use morgan('combined')
app.use bodyParser.urlencoded({extended:false})
app.use bodyParser.json()
app.use errorhandler() if app.get('env') is 'development'
app.use connect.static
app.use(rollbar.errorHandler('b2a13f53cc6b444a92e9234dd1fe37fd'))

# Routes
(require path.resolve 'routes','httpRoutes') app

mongodb_uri = process.env.MONGOLAB_URI or
              process.env.MONGOHQ_URL or
              'mongodb://localhost/unific'

mongoose.connect mongodb_uri

exports = module.exports = app
