###
# View Helpers
### 
root = exports ? this
root.ViewHelper = 

  candCheckbox: (candidate)->
    "<li>
      <input type='checkbox' siteurl=#{candidate.url} title= '#{candidate.sitetitle}' value='#{candidate.url}'>  #{candidate.sitetitle}
    </li>"

  feedList    : (feed) ->
    "<li>
      <input type='checkbox' url= '#{feed.url}' #{'checked' if feed.alive is true}>
      #{feed.title}
      <small> #{feed.site} </small>
     </li>
    "

  mediaHead: (obj)->
    return "
      <li class='media well' pubDate= '#{Date.parse obj.pubDate}'>
        <div class='media-body' id='#{obj.id}'>
          <a href=#{obj.url}>
            <h4 class='media-heading'>#{obj.title}   
              <a href='#{obj.siteurl}''>
                 <small>#{obj.sitename}</small>
              </a>
            </h4>
          </a>
          <i class='icon-pencil'> #{moment(obj.pubDate).fromNow()}</i>
          <i class='icon-comments-alt'>  Comments(<num class='commentsLength'>#{obj.comments.length}</num>) </i>
          <span class= 'starred'>
            <i class='icon-star-empty'> Unstarred</i>
          </span>
          <br><br>
          <p class ='desc'>#{obj.description}</p>
          <p class='contents'></p>
          <div class='comments'>
    "
  comment: (body)-> 
          return "
          <blockquote>#{body}</blockquote>
          "
  mediaFoot: ->
    return "
          </div>
          <input type='text' placeholder='Comment...' class='inputComment input-medium search-query'>
          <button  class='btn submitComment'><i class='icon-comment-alt'></i>  Comment</button>
          <button class='btn btn-toggle'><i class='icon-hand-right'></i>  Read More</button>
          <button class='btn btn-info'><i class='icon-star'></i>  Star</button>
        </div>
      </li>"

