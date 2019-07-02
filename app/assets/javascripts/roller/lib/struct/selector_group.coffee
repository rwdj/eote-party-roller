# selector_group.coffee
#
# Impliments a group of selectable dice of a specifc type (i.e.: ability)
#
#= require ../dice_data_handler
#= require_self
#= require ./selector_group/selector
#= require ./selector_group/selector_collection

class @SelectorGroup
  @all: []

  @init: ->
    window.DiceDataHandler.init()
    for dieGroup in document.querySelectorAll '.dice-selection-dice'
      new @(dieGroup)

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
      window.DiceDataHandler.set(@dieName, selectorIndex + 1)
    else
      window.DiceDataHandler.remove(@dieName)

  _reset: ->
    @_selectors.last.reset()

  _initSelectors: (firstNode) ->
    @_selectors = new @constructor.SelectorCollection(firstNode, @)

    initialActive = window.DiceDataHandler.fetch()[@dieName]
    initialDieCount = Math.max(5, initialActive) || 5
    while @_selectors.length < initialDieCount
      @_selectors.expand()
    @_selectors.toggle(initialActive - 1) if initialActive
