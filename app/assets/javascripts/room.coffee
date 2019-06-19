# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# App.chatChannel = App.cable.subscriptions.create "ChatChannel",
#   received: (data) ->
#     scrollDiv = document.createElement('div')
#     console.log(data.messages)
#     scrollDiv.textContent = data.messages
#     document.getElementById('speaker').appendChild(scrollDiv)
#   appendLine: (data) ->
#     console.log(data.messages)
#   createLine: (data) ->
#     """
#     <article class="chat-line">
#       <span class="speaker">#{data["sent_by"]}</span>
#       <span class="body">#{data["body"]}</span>
#     </article>
#     """
#   speak: (message) ->
#     @perform 'speak', messages: messageå