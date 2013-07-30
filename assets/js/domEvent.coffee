###
#
# domEvent.coffee
# 背景描画やCSS変更などのDOM要素を扱うイベント定義
#
###

root = exports ? this
root.DomEvent =

 pushedUsage : ->
  $Articles.css
    zIndex:10
  $('body').chardinJs('start')
  $('body').click ->
    $('body :not(#UsageButton)').chardinJs('stop')
  
  requestUploadImage : (e)->
    ## Request Change Background
    file = event.target.files[0]
    fileReader = new FileReader()
    upload file, (binary)->
      socket.emit "upload bg", 
        file : binary
        name : file.name
        stream : path

  receivedUploadImage : (image_path)->
    bgpath = "url(#{image_path})" ? "none"
    $Background.css
      backgroundImage:bgpath
      opacity:'0.2'

  requestChangeDesc : ->
    socket.emit 'change desc',
      text:$InputDesc.text()
      stream:path

  receivedChangeDesc : ->
    $InputDesc.text(data.text)

  requestClearBg : ->
    socket.emit 'clear bg',
      stream: path

  receivedClearBg : ->
    $Background.css
      backgroundImage:"none"
      opacity:'0.2'

# Upload
upload = (file,callback) ->
  fileReader = new FileReader()
  data = {}
  fileReader.readAsBinaryString file
  fileReader.onload = (event) ->
    callback event.target.result