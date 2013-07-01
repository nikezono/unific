###

  homeEvent.coffee

###

module.exports.homeEvent = (app) ->

  index: (req,res,next)->
    res.render "index",
      title : 'newstream'

  about: (req,res,next)->
    res.send "about"
