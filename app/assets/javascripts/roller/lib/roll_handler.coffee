# Handles rolls made my the user
#
#= require ./dice_pool_extractor

class @RollHandler
  @init: -> @_initDependencies()

  @roll: -> window.DicePoolExtractor.extract().roll()

  @_initDependencies: ->
    window.SelectorGroup.init()
    window.DicePoolExtractor.init()
    window.ResultHandler.init()

document.addEventListener 'turbolinks:load', ->
  window.RollHandler.init()
  for rollBtn in document.querySelectorAll '.btn.roll'
    rollerPage = document.getElementById rollBtn.dataset.page
    rollBtn.addEventListener 'click', ->
      if rollerPage.classList.contains('open') then window.RollHandler.roll()
