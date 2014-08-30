###

  PageEvent.coffee

###

module.exports.PageEvent = (app) ->

  debug = require("debug")("events/page")

  Page        = app.get("models").Page
  HelperEvent = app.get("events").HelperEvent app

  ### HTTP Events ###
  getPagesByStream:(req,res)->
    HelperEvent.getArticlesByStreamWithLimit req.params.stream,100,(err,pages)->
      debug err if err
      return res.send 400,'Internal Server Error' if err
      return res.json pages

  ### socket.io events ###
  addStar: (socket,io,data) ->
    Page.findOne _id:data.domid,(err,page)->
      if err
        debug err
        return HelperEvent.error err,socket
      page.addStar (number)->
        io.sockets.emit 'starred',
          domid:data.domid
          number:number

  addComment:(socket,io,data)->
    Page.findOne _id:data.domid, (err,page)->
      return socket.emit 'error' if err
      page.comments.push data.comment
      page.comments = _.uniq page.comments, (comment)->
        return comment
      page.save()
      io.sockets.to(data.stream).emit 'comment added',
        domid:data.domid
        comments:page.comments

