# Parses results onto the roller page
#
#= require ./struct/templates
#= require ./struct/selector_group

class @ResultHandler
  @init: ->
    @_result_nodes = {}
    for result_type in ['pool-results', 'dice-results']
      @_load_roller_result_nodes(result_type)

  @set: (results, grouped_dice) ->
    @_reset()
    @_set_results(results, @_result_nodes.pool_results)
    @_set_dice(grouped_dice, @_result_nodes.dice_results)

  @insert: (results, grouped_dice) ->
    @_set_dice(grouped_dice,
      document.querySelectorAll("#rolls tr:first-child td .dice-results")[0])
    @_set_results(results,
      document.querySelectorAll("#rolls tr:first-child td .pool-results")[0])

  @_load_roller_result_nodes: (type) ->
    @_result_nodes[type.replace(/-/, '_')] =
      document.querySelectorAll("#results .#{type}")[0]

  @_reset: ->
    for _, node of @_result_nodes
      node.innerHTML = ''

  @_set_results: (results, results_node) ->
    for result_type, result_count of results
      for _ in [1..result_count]
        @_set_result(result_type, results_node)

  @_set_result: (result, results_node) ->
    result_html = window.Templates.result(result)
    results_node.innerHTML += result_html

  @_set_dice: (dice, dice_node) ->
    for die_type, dice_results of dice
      for die_result in dice_results
        @_set_die(die_type, die_result, dice_node)

  @_set_die: (die, results, dice_node) ->
    die_node = @_generate_die(die, dice_node)
    for result, result_count of results
      for _ in [1..result_count]
        @_set_die_result(die_node, result)

  @_generate_die: (die_type, dice_node) ->
    die_html = window.Templates.die(die_type)
    dice_node.innerHTML += die_html
    dice_node.lastChild

  @_set_die_result: (die_node, result_type) ->
    result_html = window.Templates.result(result_type)
    die_node.innerHTML += result_html
