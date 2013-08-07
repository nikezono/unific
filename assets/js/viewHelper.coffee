###
#
# View Helpers
#
### 

root = exports ? this
root.ViewHelper = 

  candCheckbox: (candidate)->
    "<li>
      <input type='checkbox' siteurl=#{candidate.siteurl} title= '#{candidate.sitetitle}' value='#{candidate.url}'>
      <img src='#{candidate.favicon}'/ class='favicon'>
        #{candidate.sitetitle}
    </li>"

  feedList    : (feed) ->
    "<li>
      <input type='checkbox' url= '#{feed.url}' #{'checked' if feed.alive is true}>
      <img src='#{feed.favicon}'/ class='favicon'>
      #{feed.title}
      <small> #{feed.site} </small>
     </li>
    "

  starredIcon  : (bool)->
    if bool
      return    "<i class='icon-star'> Starred</i>"
    else
      return    "<i class='icon-star-empty'> Unstarred</i>"

  starredButton : (bool)->
    if bool
      starred = "<button class='btn btn-danger starredButton' value='unstar'><i class='icon-star-empty'></i>  Unstar</button>"
    else
      starred = "<button class='btn btn-info starredButton' value='star'><i class='icon-star'></i>  Star</button>"

  mediaHead: (obj)->
    return "
      <li class='media well' pubDate= '#{Date.parse obj.pubDate}'>
        <div class='media-body' id='#{obj.id}'>
          <a href='#{obj.url}' class='fancy fancybox.iframe'></a>
          <a href='#{obj.url}'>
            <h4 class='media-heading'>
              <img src='#{obj.favicon}' class='favicon' \>
              #{obj.title}   
              <a href='#{obj.siteurl}'>
                <small>
                  #{obj.sitename}
                </small>
              </a>
            </h4>
          </a>
          <i class='icon-pencil'> #{moment(obj.pubDate).fromNow()}</i>
          <i class='icon-comments-alt'>  Comments(<num class='commentsLength'>#{obj.comments.length}</num>) </i>
          <span class= 'starred'>
          " + @starredIcon(obj.starred) + "
          </span>
          <br><br>
          <p class='desc'>#{obj.description}</p>
          <p class='contents'></p>
          <div class='comments'>
    "
  comment: (body)-> 
          return "
          <blockquote>#{body}</blockquote>
          "
  mediaFoot: (obj)->
    return "
          </div>
          <input type='text' placeholder='Comment...' class='inputComment input-medium search-query'>
          <button  class='btn submitComment'><i class='icon-comment-alt'></i>  Comment</button>
          <button class='btn btn-inverse btn-toggle read-more'><i class='icon-hand-right'></i>  Read More</button>
          <span class='starButton'>
          " + @starredButton(obj.starred) + "
          </span>
        </div>
      </li>"

