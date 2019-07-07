# Handles rolls made my the user
#
#= require ./dice_pool_extractor

class @RollHandler
  @init: ->
    @_initDependencies()
    @detailsNode = document.getElementById('details')
    @detailsNode.purposeNode =
      document.getElementById('dice_pool_shadow_purpose')

  @roll: ->
    window.DicePoolExtractor.extract().roll()
    @hideDetails()

  @_initDependencies: ->
    window.SelectorGroup.init()
    window.DicePoolExtractor.init()
    window.ResultHandler.init()

  @askDetails: ->
    @detailsNode.style.display = 'block'
    @detailsNode.purposeNode.focus()

  @hideDetails: -> @detailsNode.style.display = 'none'

document.addEventListener 'turbolinks:load', ->
  window.RollHandler.init()
  # open details button
  for rollBtn in document.querySelectorAll '.btn.roll-details'
    rollerPage = document.getElementById rollBtn.dataset.page
    rollBtn.addEventListener 'click', ->
      if rollerPage.classList.contains('open')
        window.RollHandler.askDetails()

  # roll button
  for rollBtn in document.querySelectorAll '.btn.roll'
    rollBtn.addEventListener 'click', -> window.RollHandler.roll()

  # details exit
  screencover = document.querySelectorAll('#details .screencover')[0]
  screencover.addEventListener 'click', -> window.RollHandler.hideDetails()

