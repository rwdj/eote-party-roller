# Impliments the broadcast receiver (channel) for DMs

App = @App

App.dmRolls = App.cable.subscriptions.create 'GMRollsChannel', {
  received: (data) ->
    App.rolls.received(data)
}
