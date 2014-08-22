### Alert ###
window.notify =

  success:(text)->
    $.bootstrapGrowl text,
      ele:"body"
      type:'success'
      allow_dismiss: true
      align: 'right'

  info:(text)->
    html5notification text
    $.bootstrapGrowl text,
      ele:"body"
      type:'info'
      allow_dismiss: true
      align: 'right'

  danger:(text)->
    html5notification text
    $.bootstrapGrowl text,
      ele:"body"
      type:'danger'
      allow_dismiss: true
      align: 'right'

html5notification = (text)->

  show = (text)->
    notification = new Notification "Unific",
      body:text
      tag:"test"
      iconUrl:"http://nikezono.com/favicon.ico"
      icon:"http://nikezono.com/favicon.ico"

  if window.Notification.permission is "granted"
    show(text)


window.requestPermission =->
  if Notification.permission isnt "granted"
    Notification.requestPermission()
  else
    notify.info "Notification is already enabled"
