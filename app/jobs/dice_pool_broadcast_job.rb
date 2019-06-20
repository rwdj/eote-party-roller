class DicePoolBroadcastJob < ApplicationJob
  queue_as :default

  def perform(dice_pool)
    ActionCable.server.broadcast 'dice_pools', dice_pool
  end
end

