###

    app.coffee
    Expressの設定ファイル

###


# Dependency
require.all = require 'direquire'
express = require "express"
path = require "path"

app = express()

# all environments
connect =
  assets: (require 'connect-assets')
    buildDir: 'public'
  static: (require 'st')
    url: '/'
    path: path.resolve 'public'
    index: no
    passthrough: yes

mongoose = require "mongoose"

app = express()

#Express Configration
app.configure ->

  # env
  app.set 'env', process.env.NODE_ENV || 'development'
  app.set "port", process.env.PORT or 3000

  # views
  app.set "views", path.resolve "views"
  app.set "view engine", "jade"

  # including library
  app.set 'events', require.all path.resolve 'events'
  app.set 'models', require.all path.resolve 'models'
  app.set 'helper', require.all path.resolve 'helper'

  # config
  app.use express.favicon path.resolve 'public', 'favicon.ico'
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()

  # assets
  app.use connect.assets
  app.use connect.static

  # router
  app.use app.router

routes = require path.resolve 'routes','httpRoutes'
routes app

if process.env.NODE_ENV is 'production'
  console.info "mongoose connect:newstream"
  mongoose.connect "mongodb://localhost/newstream"
else
  console.info "mongoose connect:newstream"
  mongoose.connect "mongodb://localhost/newstream"


app.configure "development", ->
  app.use express.errorHandler()

exports = module.exports = app