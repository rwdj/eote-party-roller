# Impliments a group of selectable dice of a specifc type (i.e.: ability)
#
#= require ../dice_data_handler
#= require_self

class @SelectorGroup
  @all: []

  # Initialize a selector group for each selector group node found
  @init: ->
    window.DiceDataHandler.init()
    new @(group) for group in document.querySelectorAll '.dice-selection .dice'


  # Deselects all selector groups
  @reset: ->
    for selectorGroup in @all
      selectorGroup._reset()

  # Initializes a selector group
  constructor: (@groupNode) ->
    @constructor.all.push @

    @dieName = @groupNode.dataset.dieName
    @templateNode = @groupNode.children[0].cloneNode(true)
    @index = window.DiceDataHandler.fetch()[@dieName] || 0

    @_initSelectors()

  # Select the ith selector
  select: (index) ->
    @_setIndex(index)
    @_setSelectors()

  _setIndex: (@index) ->
    currentIndex = window.DiceDataHandler.fetch()[@dieName]
    if [0, currentIndex].includes @index
      window.DiceDataHandler.remove(@dieName)
      @index = 0
    else
      window.DiceDataHandler.set(@dieName, @index)

  _setSelectors: ->
    @_correctSelectors() # Update the current number of selectors
    @_toggleNodes(@index, false) # toggle n <= i on
    @_toggleNodes(@index + 1, true)  # toggle n > i off

  # Initialize the initial group's selectors
  _initSelectors: ->
    @_initNodeClickable @groupNode.children[0] # Init the first node
    @_correctSelectors() # prep the initial selectors
    @_setSelectors()

  # Update the current number of selectors
  _correctSelectors: ->
    if (selectorToAddCount = @_fetchSelectorToAddCount()) > 0
      @_addSelector() for _ in [0...selectorToAddCount]
    else
      @_removeSelector() for _ in [0...-selectorToAddCount]

  # Toggles all nodes in a certain direction starting from i
  _toggleNodes: (index, isTogglingRight) ->
    if !@groupNode.children[index - 1] then return null

    @_toggleNode(index - 1, !isTogglingRight)
    increment = if isTogglingRight then 1 else -1
    @_toggleNodes(index + increment, isTogglingRight)

  # Generates the number of selectors to be added with the current index
  _fetchSelectorToAddCount: ->
    childCount = @groupNode.children.length
    if @index < 5 then return 5 - childCount

    @index - childCount + 1

  # Turns a given selector node on or off
  _toggleNode: (index, toggleActive) ->
    if toggleActive
      return @groupNode.children[index].classList.remove('faded')

    @groupNode.children[index].classList.add('faded')

  _initNodeClickable: (node) ->
    [selectorGroup, childCount] = [@, @groupNode.children.length]
    node.addEventListener 'click', -> selectorGroup.select(childCount)
    node

  # Add a new selector node to the end of the group
  _addSelector: ->
    @groupNode.append (node = @templateNode.cloneNode true)
    @_initNodeClickable(node)

  # Removes the final selector node
  _removeSelector: -> @groupNode.removeChild @groupNode.lastChild
