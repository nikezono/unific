###
#
# domHelper.coffee
# jQueryのDOM要素を変数に格納する
# DOMの読み込み回数と参照回数を削減する
# Rootにmix_inする
#
###

root = exports ? this
root = _.extend root, 

  # In Toppage
  $GoButton        : $('#GoButton')
  $GoInput         : $('#GoInput')

  # Stream
  $Articles        : $('#Articles')
  $Background      : $('#AbsoluteBackground')

  ## Input
  $FindFeedInput   : $('#FindFeedInput')
  $InputImage      : $('#ImageInput')
  $InputDesc       : $('#Description')

  ## Button
  $FindFeedButton  : $('#FindFeedButton')
  $AddFeedButton   : $('#AddFeedButton')
  $EditFeedButton  : $('#EditFeedButton')
  $ApplyEditFeed   : $('#ApplyEditFeedButton')
  $ClearBackground : $('#ClearBg') 
  $UsageButton     : $('#UsageButton')

  ## Window
  $CandidatesModal : $('#CandidatesModalWindow')
  $EditFeedModal   : $('#EditFeedModalWindow')

  ## List
  $CandidatesList  : $('#CandidatesList')
  $FeedList        : $('#FeedList')

  ## Alert
  $NoFeedIsAdded   : $('#NoFeedIsAdded')
  $NoFeedIsFound   : $('#NoFeedIsFound')
  $NoFeed          : $('#NoFeedIsAdded')
  $NewArticle      : $('#NewArticleIsAdded')
  $NewFeed         : $('#NewFeedIsAdded')
  $EdittedList     : $('#FeedListIsEditted')
  $SomethingWrong  : $('#SomethingWrong')
