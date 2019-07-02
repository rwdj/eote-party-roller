# result_handler.coffee
#
# Parses results onto the roller page
#
#= require ./struct/templates
#= require_self

class @ResultHandler
  @TEMPLATES: window.TEMPLATES

  @init: ->
    @_result_nodes = {}
    for result_type in ['results', 'dice-results']
      @_load_result_node(result_type)

  @set: (results, grouped_dice) ->
    @_reset()
    @_set_results(results)
    @_set_dice(grouped_dice)

  @_reset: ->
    for _, node of @_result_nodes
      node.innerHTML = ''

  @_set_results: (results) ->
    for result_type, result_count of results
      for _ in [1..result_count]
        @_set_result(result_type)

  @_set_result: (result) ->
    result_html = @TEMPLATES.RESULT.replace(/\${result}/, result)
    @_result_nodes.results.innerHTML += result_html

  @_set_dice: (dice) ->
    for die_type, dice_results of dice
      for die_result in dice_results
        @_set_die(die_type, die_result)

  @_set_die: (die, results) ->
    for result, result_count of results
      die_node = @_generate_die(die)
      for _ in [1..result_count]
        @_set_die_result(die_node, result)

  @_generate_die: (die_type) ->
    die_html = @TEMPLATES.ROLLED_DIE.replace(/\${die}/, die_type)
    @_result_nodes.dice_results.innerHTML += die_html
    @_result_nodes.dice_results.lastChild

  @_set_die_result: (die_node, result_type) ->
    result_html = @TEMPLATES.DIE_RESULT.replace(/\${result}/, result_type)
    die_node.innerHTML += result_html

  @_load_result_node: (type) ->
    @_result_nodes[type.replace(/-/, '_')] =
      document.querySelectorAll("#roller-results .#{type}")[0]
