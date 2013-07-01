###

  streamEvent.coffee

###

module.exports.StreamEvent = (app) ->

  index: (req,res,next)->
    stream = req.params.stream
    res.render 'stream',
      title: "#{stream} - newstream"

  rss  : (req,res,next)->
    res.send "return combined rss"