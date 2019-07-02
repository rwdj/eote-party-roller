class GMRollsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'gm_rolls'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
