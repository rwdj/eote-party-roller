# Impliments the selection behavior within a group of selectable dice of a
# specifc type (i.e.: ability)

class @SelectorGroup.Selector
    constructor: (@_previousSelector, @node, @nextSelector) ->
      @_set false

    expand: ->
      nextNode = @node.cloneNode true
      @node.parentElement.append nextNode
      @nextSelector = new @constructor @, nextNode, null

    toggle: ->
      toBeActive = !@_isActive()
      @_set_left toBeActive
      @_set toBeActive
      @_set_right false

      didExpand = if toBeActive && @_isLast() then @expand()
      [@_isActive(), didExpand]

    isFaded: ->
      @node.classList.contains 'faded'

    reset: ->
      @_set_left false
      @_set false
      @_set_right false

    _isLast: ->
      !@nextSelector

    _isActive: ->
      !@isFaded() && (@_isLast() || @nextSelector.isFaded())

    _set: (toBeActive) ->
      if toBeActive
        return @node.classList.remove 'faded'

      @node.classList.add 'faded'

    _set_left: (toBeActive) ->
      if @_previousSelector
        @_previousSelector._set toBeActive
        @_previousSelector._set_left toBeActive

    _set_right: (toBeActive) ->
      if @nextSelector
        @nextSelector._set toBeActive
        @nextSelector._set_right toBeActive
