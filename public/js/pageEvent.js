!function(){var e;e="undefined"!=typeof exports&&null!==exports?exports:this,e.PageEvent={receivedAddStar:function(e){var t;return t=$(document).find("#"+e.domid),t.find("span.starred").html(ViewHelper.starredIcon(!0)),t.find("span.starButton").html(ViewHelper.starredButton(!0)),router.attachDomEvent(t)},receivedDeleteStar:function(e){var t;return t=$(document).find("#"+e.domid),t.find("span.starred").html(ViewHelper.starredIcon(!1)),t.find("span.starButton").html(ViewHelper.starredButton(!1)),router.attachDomEvent(t)},receivedAddComment:function(e){var t,n,r,i,o;for(t=$(document).find("#"+e.domid),t.find(".comments").html(""),o=e.comments,r=0,i=o.length;i>r;r++)n=o[r],t.find(".comments").append("<blockquote>"+n+"</blockquote>");return t.find(".commentsLength").text(e.comments.length)},requestReadMore:function(e){return e.find("a.fancy").click()},requestSubmitComment:function(e,t){var n;return n=e.find(".inputComment").val(),null!=n?t.emit("add comment",{domid:e.attr("id"),comment:n,stream:path}):void 0},requestChangeStar:function(e,t){var n;return n=e.find("button.starredButton").attr("value"),"star"===n?t.emit("add star",{domid:e.attr("id")}):"unstar"===n?t.emit("delete star",{domid:e.attr("id"),stream:path}):void 0}}}.call(this);