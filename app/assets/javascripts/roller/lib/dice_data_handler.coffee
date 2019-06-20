class DiceDataHandler
  constructor: ->

  load: ->
    @_node = document.getElementById 'dice_pool_dice'

  update: (dice_data) ->
    @_node.value = JSON.stringify dice_data

  fetch: ->
    try
      val = JSON.parse @_node.value
    catch e
      if e instanceof SyntaxError
        console.error 'Unable to parse value:', @_node.value
        SelectorGroup.reset()
        {}
      else throw e

  set: (dieName, value) ->
    data = @fetch()
    data[dieName] = value
    @update(data)

  remove: (dieName) ->
    data = @fetch()
    delete data[dieName]
    @update(data)

@DICE_DATA_HANDLER = new DiceDataHandler
