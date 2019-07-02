# selector_collection.coffee
#
# Impliments the collection behavior within a group of selectable dice of a
# specifc type (i.e.: ability)

class @SelectorGroup.SelectorCollection
  constructor: (firstNode, @_group) ->
    @_data = [@last = new window.SelectorGroup.Selector(null, firstNode, null)]
    @length = @_data.length
    @_makeLastClickable()

  expand: ->
    @_data.push (@last = @last.expand())
    @length = @_data.length
    @_makeLastClickable()

  toggle: (selectorIndex) ->
    [isActive, didExpand] = Array.prototype.slice.call(
      @_data, selectorIndex, selectorIndex + 1
    )[0].toggle()
    if didExpand then @_handleDoubleExpand()
    isActive

  _handleDoubleExpand: ->
    @_data.push (@last = @last.nextSelector)
    @length = @_data.length
    @_makeLastClickable()

  _makeLastClickable: ->
    @_initClickable(@last.node, @length - 1)

  _initClickable: (node, index) ->
    group = @_group
    node.addEventListener 'click', -> group.toggle(index)
