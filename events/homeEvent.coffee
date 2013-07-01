###

  homeEvent.coffee

###

module.exports.HomeEvent = (app) ->

  index: (req,res,next)->
    res.render "index",
      title : 'newstream'

  about: (req,res,next)->
    res.send "about"
