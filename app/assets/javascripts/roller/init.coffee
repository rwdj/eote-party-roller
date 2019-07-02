# init.coffee
#
# Initialises onload events

initDirectionButtons = ->
  for button in document.querySelectorAll '.btn.top'
    button.addEventListener 'click', ->
      window.scrollBy(0, -document.body.scrollHeight)
  for button in document.querySelectorAll '.btn.bottom'
    button.addEventListener 'click', ->
      window.scrollBy(0, document.body.scrollHeight)
document.addEventListener 'turbolinks:load', initDirectionButtons

document.addEventListener 'turbolinks:load', @initRollHandler
