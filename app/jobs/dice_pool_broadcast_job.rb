class DicePoolBroadcastJob < ApplicationJob
  queue_as :default
  DNR_SEQUENCE = DicePool::DNR_SEQUENCE

  def perform(dice_pool_hash)
    if dice_pool_hash[:purpose].match? DNR_SEQUENCE
      return send_to_dm(dice_pool_hash)
    end

    ActionCable.server.broadcast 'rolls', dice_pool_hash
  end

  def send_to_dm(dice_pool_hash)
    dice_pool_hash[:purpose].remove! DNR_SEQUENCE
    dice_pool_hash[:dnr] = true

    ActionCable.server.broadcast 'gm_rolls', dice_pool_hash
  end
end
