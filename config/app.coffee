###

    app.coffee
    Expressの設定ファイル

###


# Dependency
require.all   = require 'direquire'
flash         = require 'connect-flash'
express       = require "express"
passport      = require 'passport'
path          = require "path"

# MongoDB
mongoose = require "mongoose"
mongoose.connect   "mongodb://localhost/unific-v2"

app = express()

# all environments
connect =
  static: (require 'st')
    url: '/'
    path: path.resolve 'public'
    index: no
    passthrough: yes
  session: new ((require 'connect-mongo') express)
    mongoose_connection: mongoose.connections[0]

app = express()

# env
app.set 'env', process.env.NODE_ENV || 'development'
app.set 'port', process.env.PORT || 3001
app.set 'secret',process.env.SESSION_SECRET || 'deadbeef'
app.set 'session',connect.session

# views
app.set "views", path.resolve "views"
app.set "view engine", "jade"

# including library
app.set 'events', require.all 'events'
app.set 'models', require.all 'models'
app.set 'helper', require.all 'helper'

# passport
(require path.resolve 'config', 'auth') app,passport

# Express Middleware Configration
app.configure ->

  # config
  app.use express.favicon path.resolve 'public', 'favicon.ico'
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()

  # Auth
  app.use express.cookieParser() 
  app.use express.session
    secret: app.get 'secret'
    store: app.get 'session'

  app.use passport.initialize()
  app.use passport.session()

  # Remember Me middleware
  app.use (req, res, next) ->
    if req.method is "POST" and req.url is "/log_in"
      if req.body.rememberme
        req.session.cookie.maxAge = 2592000000 # 30*24*60*60*1000 Rememeber 'me' for 30 days
      else
        req.session.cookie.expires = false
    next()

  app.use connect.static
  app.use app.router
  app.use flash()

# Routes
(require path.resolve 'routes','httpRoutes') app,passport

app.configure "development", ->
  app.use express.errorHandler()

exports = module.exports = app
