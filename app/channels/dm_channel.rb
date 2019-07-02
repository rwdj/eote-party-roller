class RollsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'dm'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
