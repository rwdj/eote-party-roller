# Builds a dice_pool from the current page state
#
#= require ./struct/dice_pool

class @DicePoolExtractor
  @init: ->
    @rollerNode = document.getElementById('dice_pool_roller')
    @purposeNode = document.getElementById('dice_pool_shadow_purpose')
    @purposeNode.value = document.getElementById('dice_pool_purpose').value
    @swapPurpose()

  @swapPurpose: ->
    [@purposeNode.value, @purposeNode.placeholder] =
        ['', @purposeNode.value || @purposeNode.placeholder]
    @purposeNode.placeholder

  @extract: ->
    new DicePool(
      @rollerNode.value
      @swapPurpose()
      window.DiceDataHandler.fetch()
    )
