# init.coffee
#
# Initialises onload events

initSubmitButtons = ->
  for button in document.querySelectorAll '.btn.submit'
    button.addEventListener 'click', -> document.forms[0].submit()
document.addEventListener 'turbolinks:load', initSubmitButtons

initDirectionButtons = ->
  for button in document.querySelectorAll '.btn.top'
    button.addEventListener 'click', ->
      window.scrollBy(0, -document.body.scrollHeight)
  for button in document.querySelectorAll '.btn.bottom'
    button.addEventListener 'click', ->
      window.scrollBy(0, document.body.scrollHeight)
document.addEventListener 'turbolinks:load', initDirectionButtons

document.addEventListener 'turbolinks:load', @initRollHandler
