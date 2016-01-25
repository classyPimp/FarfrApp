# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  navListItems = $('div.setup-panel div a')
  allWells = $('.setup-content')
  allNextBtn = $('.nextBtn')
  allWells.hide()
  navListItems.click (e) ->
    e.preventDefault()
    $target = $($(this).attr('href'))
    $item = $(this)
    if !$item.hasClass('disabled')
      navListItems.removeClass('btn-primary').addClass 'btn-default'
      $item.addClass 'btn-primary'
      allWells.hide()
      $target.show()
      $target.find('input:eq(0)').focus()
    return
  allNextBtn.click ->
    curStep = $(this).closest('.setup-content')
    curStepBtn = curStep.attr('id')
    nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children('a')
    curInputs = curStep.find('input[type=\'text\'],input[type=\'url\']')
    isValid = true
    $('.form-group').removeClass 'has-error'
    i = 0
    while i < curInputs.length
      if !curInputs[i].validity.valid
        isValid = false
        $(curInputs[i]).closest('.form-group').addClass 'has-error'
      i++
    if isValid
      nextStepWizard.removeAttr('disabled').trigger 'click'
    return
  $('div.setup-panel div a.btn-primary').trigger 'click'
  $('.chosen').chosen({width: "95%"})
  $(document.body).on "click", '.remove_nested_fields', ->
    $(this).siblings("[id$='_document']").replaceWith("[id$='_document']").clone(true)
    return
  $(document.body).on "click", '.input-field-adder', (event) ->
    event.preventDefault()
    cloned_chosen = $(this).siblings('.chosen-box').children('.chosen:first')
    $('<div class="chosen-box"></div>').html(cloned_chosen.clone()).insertBefore($(this))
    $('<a class="input-field-remover" href="javascript:void(0)">remove contragent</a>').insertBefore($(this))
    $('.chosen').chosen({width: "95%"})
    return
  $(document.body).on "click", ".input-field-remover",(event) ->
    event.preventDefault()
    $(this).prev().remove()
    $(this).remove()
    return
  $(document.body).on 'click', '#show-approval', ->
    $('.approval-table').slideToggle('fast')
    unless $(this).children("i").length
      $(this).append($("<i class='fa fa-times pull-right'>close</i>"))
    else
      $(this).children("i").remove()
    return
  $('.approve-contract').on "ajax:complete", (e, data, status) ->
    $('.approval-cell').html data.responseJSON.approved
    return
  $('.get_comments').on "ajax:complete", (e, data, status) ->
    unless status is 'success'
      alert "there was an error try reloading comments"      
      return
    $('.comments').empty()
    json = data.responseJSON
    alert "there are no comments still, be first!" unless json[0]
    target = $('.comments')
    satisfy_btn = (comment, user)->
      if comment.user_id is user && comment.parent_id is 0 && comment.satisfied is '0'
        return "<a href='#{$('.new_contract_comment').attr('action')}/#{comment.id}?satisfy=true' class='satisfy_comment pull-right'>SATISFY</a>"
      else
        return ''
    $(document).on "click", ".satisfy_comment", (e)->
      e.preventDefault()
      url = $(this).attr('href')
      $.ajax {
        url: url
        type: "PUT"
        success: ->
          $('.get_comments').click()
      }
    recurs = (id,json,form) ->
      for comment in json
        if comment.parent_id is id
          form.append($("
          <div class='comment-node well well-sm' id=comment_node_#{comment.id}>
            <div class='comment_data' id='comment_#{comment.id}'> 
              <p>
                comment by: #{comment.user_name}, posted on #{comment.created_at}, 
                sstisfied: #{ if (comment.satisfied is '0') then "no" else comment.satisfied}
                <a class='reply_to' data-comment_id='#{comment.id}' data-parent_node='#{comment.parent_node}'> reply </a>
                #{satisfy_btn(comment, $('.user_info').data('user_id'))}
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
    form = $('.new_contract_comment')
    form.appendTo($(this).parents('.well:first'))
    form.children('.cancel-reply').show()
    if parent.data('parent_node') is 0
      form.children('#contract_comment_parent_node').val(parent.data("comment_id"))
    else
      form.children('#contract_comment_parent_node').val(parent.data("parent_node"))
    form.children('#contract_comment_parent_id').val(parent.data("comment_id"))  
    return
  $(document.body).on "click", '.cancel-reply', (event) ->
    event.preventDefault()
    form = $('.new_contract_comment')
    form.children('.cancel-reply').hide()
    form.appendTo($('.comment-box'))
    form.children('#contract_comment_parent_node').val(0)
    form.children('#contract_comment_parent_id').val(0)
    return 
  $('.new_contract_comment').on "ajax:complete", (e, data, status) ->
    if status is 'success'
      $('.cancel-reply').click() unless $('.cancel-reply').css('display') is 'none'
      console.log $('.new_contract_comment').children('#contract_comment_body').val('')
      $('.get_comments').click()
    else
      alert "there was, an error try again!"
    return
  $(document.body).on "click", "#search-form",  (event) ->
    event.preventDefault()
    $(".search-contracts").toggle "fast"
    $("#search-form").toggle "fast"
    return
  $(document).on "click", "#cancel-search", ->
    $(".search-contracts").toggle "fast"
    $("#search-form").toggle "fast"
    return
  $(document).on "click", "#show-after-approval-actions", (e)->
    e.preventDefault
    $(".after_approval_container").toggle()
    return
  $(document).on "click", ".after_approval_form_btn", (e)->
    e.preventDefault
    div = $($(this).data("form")).first().clone()
    target = $('.additional_info_form_box')
    target.html($(div))
    return
  $(document).on "ajax:complete", '.after_approval_form', (e,d,s) ->
    destination = $(e.target).data('destination')
    $(destination).html(d.responseJSON.response)
    unless $(e.target).hasClass('upload_signed_scans')
      btn_data_form = $(e.target).parents('.additional_info_form_box').children('div').first().attr('class').split(' ')[0]
      $(e.target).parents('.additional_info_form_box').first().html('')
      $("button[data-form='.#{btn_data_form}']").remove()    
    return
  $(document).on 'click', '#edit-contract', (e) ->
    $('.edit-contract-form').toggle() 
  return

  

  
  