###
#
# globalObject.coffee
# クライアントサイドのグローバル変数たち
#
###

root = exports ? this
root.Articles = []    # 全Articlesを格納したArray


###
# helper methods
###

root.showFade = ($dom)->
  $dom.toggle('fade',500)
  setTimeout ->
    $dom.toggle('fade',500)
  ,5000

# Configure FancyBox 

root.configureFancyBox = ($dom)->
  $dom.find(".fancy").fancybox
    fitToView : false
    width   : '70%'
    height    : '100%'
    autoSize  : true
    closeClick  : true
    openEffect  : 'none'
    closeEffect : 'none'  