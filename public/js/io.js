!function(){var e=[].indexOf||function(e){for(var t=0,n=this.length;n>t;t++)if(t in this&&this[t]===e)return t;return-1};$(function(){var t,n,r,i,o,a,d,c,u,s,l,f,m,p,h,g,v,b,k,y,w,F,I,B,x,H,V,A,D,C,E,L;return $(".alert").hide(),$("button.close").click(function(e){return e.currentTarget.parentElement.style.display="none"}),E=io.connect(),D=window.location.pathname.substr(1),V=!0,x=[],p=$("#GoButton"),h=$("#GoInput"),r=$("#Articles"),i=$("#AbsoluteBackground"),m=$("#FindFeedInput"),v=$("#ImageInput"),g=$("#Description"),f=$("#FindFeedButton"),t=$("#AddFeedButton"),c=$("#EditFeedButton"),n=$("#ApplyEditFeedButton"),d=$("#ClearBg"),B=$("#UsageButton"),a=$("#CandidatesModalWindow"),u=$("#EditFeedModalWindow"),o=$("#CandidatesList"),l=$("#FeedList"),w=$("#NoFeedIsAdded"),F=$("#NoFeedIsFound"),y=$("#NoFeedIsAdded"),b=$("#NewArticleIsAdded"),k=$("#NewFeedIsAdded"),s=$("#FeedListIsEditted"),I=$("#SomethingWrong"),E.on("connect",function(){var e,N;return A()?(E.emit("connect stream",D),V&&(E.emit("sync stream",D),""===r.html()&&w.show(),V=!1),setInterval(function(){return console.log("sync"),E.emit("sync stream",D)},6e4),B.click(function(){return r.css({zIndex:10}),$("body").chardinJs("start")}),$("body").click(function(){return $("body :not(#UsageButton)").chardinJs("stop")}),f.click(function(){return F.hide(),E.emit("find feed",m.val())}),E.on("found feed",function(e,t){var n,r,i,d;if(null!=e&&F.show(),null!=t.candidates){for(o.html(""),d=t.candidates,r=0,i=d.length;i>r;r++)n=d[r],n.sitetitle=""+n.sitename+" - "+(n.title||"feed"),n.siteurl=t.url,o.append(ViewHelper.candCheckbox(n));return a.modal()}}),E.on("sync completed",function(t){var n,r,i,o,a;for(i=_.sortBy(t,function(e){return Date.parse(e.page.pubDate)}),0!==t.length&&y.hide(),n=!1,o=0,a=i.length;a>o;o++)r=i[o],n=H(r);return e(),N(),n?C(b):void 0}),c.click(function(){return E.emit("get feed_list",D)}),E.on("got feed_list",function(e){var t,n,r;if(null!=e){for(l.html(""),n=0,r=e.length;r>n;n++)t=e[n],l.append(ViewHelper.feedList(t));return u.modal()}}),n.click(function(){var e;return e=[],l.find(":checkbox:checked").each(function(){return e.push($(this).attr("url"))}),E.emit("edit feed_list",{urls:e,stream:D})}),E.on("edit completed",function(){return C(s),x=[],r.html(""),console.log("sync by feed_list editted"),E.emit("sync stream",D)}),v.change(function(){var e,t;return e=event.target.files[0],t=new FileReader,L(e,function(t){return E.emit("upload bg",{file:t,name:e.name,stream:D})})}),E.on("bg uploaded",function(e){var t,n;return console.log(e),t=null!=(n="url("+e+")")?n:"none",i.css({backgroundImage:t,opacity:"0.2"})}),d.click(function(){return E.emit("clear bg",{stream:D})}),E.on("bg cleared",function(){return i.css({backgroundImage:"none",opacity:"0.2"})}),g.keyup(function(){return E.emit("change desc",{text:g.text(),stream:D})}),E.on("desc changed",function(e){return g.text(e.text)}),t.click(function(){var e;return e=[],o.find(":checkbox:checked").each(function(){return e.push({url:$(this).val(),title:$(this).attr("title"),siteurl:$(this).attr("siteurl")})}),0!==e.length?E.emit("add feed",{urls:e,stream:D}):void 0}),E.on("add-feed succeed",function(){return C(k),console.log("sync"),E.emit("sync stream",D)}),E.on("star added",function(e){var t;return t=$(document).find("#"+e.domid),t.find("span.starred").html(ViewHelper.starredIcon(!0)),t.find("span.starButton").html(ViewHelper.starredButton(!0)),N()}),E.on("star deleted",function(e){var t;return t=$(document).find("#"+e.domid),t.find("span.starred").html(ViewHelper.starredIcon(!1)),t.find("span.starButton").html(ViewHelper.starredButton(!1)),N()}),E.on("comment added",function(e){var t,n,r,i,o;for(t=$(document).find("#"+e.domid),t.find(".comments").html(""),o=e.comments,r=0,i=o.length;i>r;r++)n=o[r],t.find(".comments").append("<blockquote>"+n+"</blockquote>");return t.find(".commentsLength").text(e.comments.length)}),E.on("error",function(){return C(I)}),e=function(){return $(".fancy").fancybox({fitToView:!1,width:"70%",height:"100%",autoSize:!0,closeClick:!0,openEffect:"none",closeEffect:"none"}),$(".read-more").click(function(){var e;return e=$(this).parent(),e.find("a.fancy").click()}),$(".submitComment").click(function(){var e,t;return e=$(this).parent(),t=e.find(".inputComment").val(),null!=t?E.emit("add comment",{domid:e.attr("id"),comment:t,stream:D}):void 0})},N=function(){return $(".starredButton").click(function(){var e,t;return e=$(this).parent().parent(),t=$(this).attr("value"),"star"===t?E.emit("add star",{domid:e.attr("id")}):"unstar"===t?E.emit("delete star",{domid:e.attr("id"),stream:D}):void 0})}):p.click(function(){return window.location.href=h.val()})}),C=function(e){return e.toggle("fade",500),setTimeout(function(){return e.toggle("fade",500)},5e3)},A=function(){return""===D?!1:!0},L=function(e,t){var n,r;return r=new FileReader,n={},r.readAsBinaryString(e),r.onload=function(e){return t(e.target.result)}},H=function(t){var n,i,o,a,d,c,u,s,l,f,m,p;for(l={title:t.page.title,id:t.page._id,comments:t.page.comments,description:t.page.description,pubDate:t.page.pubDate,url:t.page.url,sitename:t.feed.title,favicon:t.feed.site.match(/http:\/\/.+?\//)+"favicon.ico",siteurl:t.feed.site,starred:t.page.starred},i="",p=t.page.comments,f=0,m=p.length;m>f;f++)n=p[f],i+=ViewHelper.comment(n);return s=r.find("li:first").attr("pubDate"),c=Date.parse(l.pubDate),d=c>=s,a=void 0===s,u=l.title,o=e.call(x,u)>=0,d&&!o||a?(r.prepend(ViewHelper.mediaHead(l)+i+ViewHelper.mediaFoot(l)).hide().fadeIn(500),x.push(u),!0):!1}})}.call(this);