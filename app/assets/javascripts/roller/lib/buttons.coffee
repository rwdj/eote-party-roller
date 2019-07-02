# Initializes buttons on the page after loading

# Index Buttons
toggleDisplays = (elem1, elem2) ->
  elem1Display = getDisplay(elem2)
  elem2.style.display = getDisplay(elem1)
  elem1.style.display = elem1Display

getDisplay = (element) ->
  if element.currentStyle
    return element.currentStyle.display
  getComputedStyle(element, null).display

document.addEventListener 'turbolinks:load', ->
  rollerNode = document.getElementById 'roller'
  rollsNode = document.getElementById 'rolls'
  for button in document.querySelectorAll '.btn.toggle-index'
    button.addEventListener 'click', ->
      toggleDisplays(rollerNode, rollsNode)

# Directional Buttons
document.addEventListener 'turbolinks:load', ->
  for button in document.querySelectorAll '.btn.top'
    button.addEventListener 'click', ->
      window.scrollBy(0, -document.body.scrollHeight)
  for button in document.querySelectorAll '.btn.bottom'
    button.addEventListener 'click', ->
      window.scrollBy(0, document.body.scrollHeight)
