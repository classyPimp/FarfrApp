# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
   
  $('.user_notifications_form').on('ajax:success', (e, d, s, x)->
    nc = $('.notification_checkbox:input:checked').closest('.single_notification')
    $('.notifications_count').text($('.notifications_count').text() - nc.length)
    nc.remove()
    if (nc = $('#set_read_checkboxes')).is(':checked')
      nc.prop('checked', false)
    return
    ).on 'ajax:error', (x,s,e)->
    alert "there was an error please reload the page!"
    return
  $(document).on 'click', '#set_read_checkboxes', (e)->
    x = $(this).is(':checked')
    $('.notification_checkbox').prop('checked', x)

