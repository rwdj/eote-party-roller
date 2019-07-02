# roll_handler.coffee
#
# Handles rolls made my the user
#
#= require ./dice_pool_extractor
#= require_self

class @RollHandler
  @init: -> @_initDependencies()

  @roll: -> window.DicePoolExtractor.extract().roll()

  @_initDependencies: ->
    window.SelectorGroup.init()
    window.DicePoolExtractor.init()
    window.ResultHandler.init()

@initRollHandler = ->
  window.RollHandler.init()
  for rollBtn in document.querySelectorAll '.btn.roll'
    rollBtn.addEventListener 'click', -> window.RollHandler.roll()
