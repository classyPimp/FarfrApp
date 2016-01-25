# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.get_regular_comments').on "ajax:complete", (e, data, status) ->
    unless status is 'success'
      alert "there was an error try reloading comments"      
      return
    $('.comments').empty()
    json = data.responseJSON
    alert "there are no comments still, be first!" unless json[0]
    target = $('.comments')
    
    recurs = (id,json,form) ->
      for comment in json
        if comment.parent_id is id
          form.append($("
          <div class='comment-node well well-sm' id=comment_node_#{comment.id}>
            <div class='comment_data' id='comment_#{comment.id}'> 
              <p>
                comment by: #{comment.user_name}, posted on #{comment.created_at}, 
                
                <a class='reply_to' data-comment_id='#{comment.id}' data-parent_node='#{comment.parent_node}'> reply </a>
                
              </p>
            </div>       
            <hr>
            <p> #{comment.body} </p>
          </div>
          "))
          if !form.children('.well:last-child').children('.children:last-child').length
            form.children('.well:last-child').append('<div class="children"></div>')
          shingle = form.children('.well:last-child').children('.children')
          recurs(comment.id,json,shingle)
      return
    recurs(0, json, target)
    $(this).children(".get_comments").val("refresh comments")
    
    return
  $(document).on "click", ".reply_to", ->
    parent = $(this)
    form = $('.new_comment')
    form.appendTo($(this).parents('.well:first'))
    form.children('.cancel-reply').show()
    if parent.data('parent_node') is 0
      form.children('#comment_parent_node').val(parent.data("comment_id"))
    else
      form.children('#comment_parent_node').val(parent.data("parent_node"))
    form.children('#comment_parent_id').val(parent.data("comment_id"))  
    return
  $(document.body).on "click", '.cancel-reply', (event) ->
    event.preventDefault()
    form = $('.new_comment')
    form.children('.cancel-reply').hide()
    form.appendTo($('.comment-box'))
    form.children('#comment_parent_node').val(0)
    form.children('#comment_parent_id').val(0)
    return 
  $('.new_comment').on "ajax:complete", (e, data, status) ->
    if status is 'success'
      $('.cancel-reply').click() unless $('.cancel-reply').css('display') is 'none'
      $('.get_comments').click()
    else
      alert "there was, an error try again!"
    return
  $(document).on 'click', '.file-report', ->
    x = $('.assignee_panel')
    if x.is(':visible')
      x.fadeOut()
    else
      x.fadeIn()


    