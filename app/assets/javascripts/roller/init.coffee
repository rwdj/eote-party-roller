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

initSelectors = ->
  window.DICE_DATA_HANDLER.load()
  for dieGroup in document.querySelectorAll '.dice-selection-dice'
    new window.SelectorGroup(dieGroup)
document.addEventListener 'turbolinks:load', initSelectors
