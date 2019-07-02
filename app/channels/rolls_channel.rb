class RollsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'rolls'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
