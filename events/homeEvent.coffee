###

  HomeEvent.coffee

###

module.exports.HomeEvent = (app) ->

  index: (req,res,next)->
    res.render "index",
      title : 'unific'

  about: (req,res,next)->
    res.send "about"
