!function(){var e;e="undefined"!=typeof exports&&null!==exports?exports:this,e.path=window.location.pathname.substr(1),$(function(){var t,n;return t=!0,$(".alert").hide(),$("button.close").click(function(e){return e.currentTarget.parentElement.style.display="none"}),n=io.connect(),e.router=routes(n),n.on("connect",function(){return _.isEmpty(path)||n.emit("connect stream",path),router.attachSingleEvent(),t&&(n.emit("sync stream",{stream:path,latest:latestPubDate()}),""===$Articles.html()&&$NoFeedIsAdded.show(),t=!1),setInterval(function(){return console.log("sync by 1minutes"),n.emit("sync stream",{stream:path,latest:latestPubDate()})},3e5)})})}.call(this);