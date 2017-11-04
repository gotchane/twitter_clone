# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', -> 
  if $('.js-room').length != 0 && $('.room-messages__page li').length != 0
    page = $('.room-messages__page')
    markReadUrl = $('.js-room').data('url')
    lastReadMsgId = $('.js-room').data('msgid')
    lastReadMsg = $('.room-messages__item--' + lastReadMsgId)
    latestMsg = $('.room-messages__page li:last-child')
    if lastReadMsg.length != 0
      lastReadMsgPos = lastReadMsg.position().top
    else
      lastReadMsgPos = 0
    jumpPos = page[0].scrollHeight - latestMsg.outerHeight() - (latestMsg.position().top) - lastReadMsg.outerHeight() + lastReadMsgPos
    page.animate { scrollTop: jumpPos }, 0
    $('.room-messages__page li:last-child').on 'inview', ->
      $.ajax
        type: 'get'
        url: markReadUrl
        cache: false
        dataType: 'json'
