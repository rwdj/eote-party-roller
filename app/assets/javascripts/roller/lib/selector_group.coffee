#= require_self
#= require ./selector_group/selector
#= require ./selector_group/selector_collection

class @SelectorGroup
  @all: []

  @reset: ->
    for selectorGroup in @all
      selectorGroup._reset()

  constructor: (groupNode) ->
    @constructor.all.push @

    firstNode = groupNode.children[0]
    @dieName = groupNode.dataset.dieName
    @_initSelectors(firstNode)

  toggle: (selectorIndex) ->
    isActive = @_selectors.toggle(selectorIndex)
    if isActive
      DICE_DATA_HANDLER.set(@dieName, selectorIndex + 1)
    else
      DICE_DATA_HANDLER.remove(@dieName)

  _reset: ->
    @_selectors.last.reset()

  _initSelectors: (firstNode) ->
    @_selectors = new @constructor.SelectorCollection(firstNode, @)

    initialActive = DICE_DATA_HANDLER.fetch()[@dieName]
    initialDieCount = Math.max(5, initialActive) || 5
    while @_selectors.length < initialDieCount
      @_selectors.expand()
    @_selectors.toggle(initialActive - 1) if initialActive
