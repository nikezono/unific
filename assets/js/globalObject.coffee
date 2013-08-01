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
  $dom.stop(true,true)
  $dom.toggle('fade',500).delay(3000).toggle('fade',500)

root.latestPubDate = -> 
  $Articles.find('li:first').attr('pubDate')

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