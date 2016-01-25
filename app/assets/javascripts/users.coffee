# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  
  $("#show_unapproved_contracts_for_user").on "ajax:before", ->
    if (x = $(".unapproved-contracts-panel")).is(":visible")
      x.toggle("fast")
      return false
    else
      x.toggle("fast")
    return
  #TODO THAT METHOD TGLCONTPNL SHALL BE CALLED ON SUCCESS INSTED OF THIS
  $(".refresh_unapproved_contracts_for_user").on "ajax:success", (event,data, status, xhr)->
    $('.unapproved_contracts_for_user').html(data)
    $('.unapproved-contracts-panel').toggle('fast')

  $(document.body).on 'click', '.toggle_contracts_links_panel', (e) ->
    $('.users_contracts_links_panel_body').toggle()
    $(this).toggleClass("fa-arrow-circle-o-down")
    return

  $('#confirmations').on("ajax:success", (e,d,s,x)->
    nc = $('.confirmations_checkbox:input:checked').closest('.confirmation-request-box')
    $('.confirmations_count').text($('.confirmations_count').text() - nc.length)
    nc.remove()
    return
    ).on 'ajax:error', (x,s,e)->
    alert "there was an error please reload the page!"
    return
      


