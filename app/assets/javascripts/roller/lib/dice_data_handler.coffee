# Handles fetching and seting dice in the page

class @DiceDataHandler
  @init: ->
    @_node = document.getElementById 'dice_pool_dice'

  @update: (dice_data) ->
    @_node.value = JSON.stringify dice_data

  @fetch: ->
    try
      val = JSON.parse @_node.value
    catch e
      if e instanceof SyntaxError
        console.error 'Unable to parse value:', @_node.value
        window.SelectorGroup.reset()
        {}
      else throw e

  @set: (dieName, value) ->
    data = @fetch()
    data[dieName] = value
    @update(data)

  @remove: (dieName) ->
    data = @fetch()
    delete data[dieName]
    @update(data)
