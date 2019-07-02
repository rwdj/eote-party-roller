# Builds a dice_pool from the current page state
#
#= require ./struct/dice_pool

class @DicePoolExtractor
  @_nodes: {}

  @init: ->
    @_nodes.roller = document.getElementById 'dice_pool_roller'
    @_nodes.purpose = document.getElementById 'dice_pool_purpose'

  @extract: ->
    new DicePool(
      @_nodes.roller.value
      @_nodes.purpose.value
      window.DiceDataHandler.fetch()
    )
