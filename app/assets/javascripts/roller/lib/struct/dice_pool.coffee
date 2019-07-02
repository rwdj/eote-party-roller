# dice_pool.coffee
#
# Impliments a rollable dicepool object
#= require_self
#= require ../result_handler

class @DicePool
  constructor: (@roller, @purpose, @dice) ->

  roll: ->
    Rails.ajax {
      url: '/roll.js'
      type: 'post'
      dataType: 'JSON'
      data: @roll_data()
      success: (data) ->
        ResultHandler.set(
          JSON.parse(data.result), JSON.parse(data.dice)
        )
    }

  roll_data: ->
    $.param {
        dice_pool:
          {
            roller: @roller
            purpose: @purpose
            view_dice: JSON.stringify @dice
          }
      }
