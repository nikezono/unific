###

    app.coffee
    Expressの設定ファイル

###


# Dependency
require.all   = require 'direquire'
express       = require "express"
passport      = require 'passport'
path          = require "path"
cluster       = require 'cluster'

app = express()

# all environments
connect =
  static: (require 'st')
    url: '/'
    path: path.resolve 'public'
    index: no
    passthrough: yes

mongoose = require "mongoose"

app = express()

# env
app.set 'env', process.env.NODE_ENV || 'development'
app.set 'port', process.env.PORT || 3001
app.set 'domain', ['localhost','unific.net','unific.nikezono.net','net45-dhcp160.sfc.keio.ac.jp']

# views
app.set "views", path.resolve "views"
app.set "view engine", "jade"

# including library
app.set 'events', require.all path.resolve 'events'
app.set 'models', require.all path.resolve 'models'
app.set 'helper', require.all path.resolve 'helper'

# passport
(require path.resolve 'config', 'auth') app,passport

# Express Middleware Configration
app.configure ->

  # config
  app.use express.favicon path.resolve 'public', 'favicon.ico'
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser('keyboard cat') 
  app.use express.session({ secret: 'keyboard cat',cookie: { maxAge: 60000 }})

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

  # static
  app.use connect.static

  # router
  app.use app.router

# Routes
(require path.resolve 'routes','httpRoutes') app,passport

if process.env.NODE_ENV is 'production'
  console.info "mongoose connect:unific"
  mongoose.connect "mongodb://localhost/unific"
else
  console.info "mongoose connect:unific-dev"
  mongoose.connect "mongodb://localhost/unific-dev"

app.configure "development", ->
  app.use express.errorHandler()

exports = module.exports = app
