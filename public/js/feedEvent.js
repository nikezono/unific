!function(){var e;e="undefined"!=typeof exports&&null!==exports?exports:this,e.FeedEvent={requestFeedList:function(e){return e.emit("get feed_list",path)},receivedFeedList:function(e){var t,n,r;if(null!=e){for($FeedList.html(""),n=0,r=e.length;r>n;n++)t=e[n],$FeedList.append(ViewHelper.feedList(t));return $EditFeedModal.modal()}return console.log("no feed")},requestEditFeedList:function(e,t){var n;return n=[],$FeedList.find(":checkbox:checked").each(function(){return n.push($(e).attr("url"))}),t.emit("edit feed_list",{urls:n,stream:path})},receivedEditFeedList:function(e){var t;return showFade($EdittedList),t=[],$Articles.html(""),console.log("sync by feed_list editted"),e.emit("sync stream",path)},requestAddFeed:function(){var e;return e=[],$CandidatesList.find(":checkbox:checked").each(function(){return e.push({url:$(this).val(),title:$(this).attr("title"),siteurl:$(this).attr("siteurl")})}),0!==e.length?socket.emit("add feed",{urls:e,stream:path}):void 0},receivedAddFeed:function(){return showFade($NewFeed),console.log("sync by add feed"),socket.emit("sync stream",path)}}}.call(this);