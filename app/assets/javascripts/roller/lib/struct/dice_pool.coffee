# dice_pool.coffee
#
# Impliments a rollable dicepool object
#= require_self
#= require ../result_handler

class @DicePool
  constructor: (@roller, @purpose, @dice) ->

  roll: ->
    dice_pool = @
    Rails.ajax {
      url: '/roll.js'
      type: 'post'
      dataType: 'JSON'
      data: @_roll_data()
      success: (data) ->
        dice_pool._clear_error()
        ResultHandler.set(JSON.parse(data.result), JSON.parse(data.dice))
      error: (error) -> dice_pool._notify_error(error.message)
    }

  _roll_data: ->
    $.param {
        dice_pool:
          {
            roller: @roller
            purpose: @purpose
            view_dice: JSON.stringify @dice
          }
      }

  _notify_error: (error) ->
    document.getElementById('notice').innerHTML = error

  _clear_error: ->
    @_notify_error ''
