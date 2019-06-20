class DicePoolsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'dice_pools'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
