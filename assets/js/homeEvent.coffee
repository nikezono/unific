###
#
# homeEvent.coffee
# パス無しのhome画面/ストリームの初期画面でのイベント定義
#
###

root = exports ? this
root.HomeEvent =

  goStream     : -> 
    window.location.href = $GoInput.val()
  