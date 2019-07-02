# channel.coffee
#
# Impliments the broadcast receiver (channel) for DMs
#
#= require_self

@App = {}

App.cable = ActionCable.createConsumer()

App.dmRolls = App.cable.subscriptions.create 'DMRollsChannel', {
  received: (data) ->
    window.ROLLS_CHANNEL.recieved(data)
}
