###

  FeedEvent.coffee

###

debug = require('debug')('events/feed')

module.exports.FeedEvent = (app) ->

  HelperEvent = app.get('events').HelperEvent app
  Feed        = app.get('models').Feed
  Stream      = app.get('models').Stream

  # Feed List
  list:(req,res,next)->
    streamName = req.params.stream
    Stream.findOne({title:streamName})
    # @todo Streamの購読
    .populate "feeds"
    .exec (err,stream)->
      return HelperEvent.httpError err,res if err
      resArray = []
      for feed in stream.feeds
        feedObj = feed.toObject()
        feedObj.subscribed = true
        resArray.push feedObj
      return res.json resArray


